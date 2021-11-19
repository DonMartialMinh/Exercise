//
//  StampViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/26/21.
//

import UIKit
import SVProgressHUD
import RealmSwift

class StampViewController: UIViewController {
    private var stampsFromJson: [StampFromJson] = []
    private var stamps: Results<Stamp>?
    private var viewModel = StampViewModel()
    private var type: ItemType = .stamps
    private var selectedIndex: IndexPath?
    private enum ItemType {
        case stamps
        case stampsFromJson
    }

    // MARK: - IBOutlet
    @IBOutlet weak var stampCollectionView: UICollectionView!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stampCollectionView.register(ImageCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
        stampCollectionView.delegate = self
        stampCollectionView.dataSource = self
        stampCollectionView.allowsMultipleSelection = false
        viewModel.delegate = self
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = stampCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDatasource
extension StampViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .stamps:
            return stamps?.count ?? 0
        case .stampsFromJson:
            return stampsFromJson.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCellIdentifier, for: indexPath) as! ImageCollectionViewCell
        switch type {
        case .stamps:
            if let imageUrl = stamps?[indexPath.row].thumbnailImageUrl {
                cell.pictureImageView.loadFromUrl(imageUrl)
                cell.pictureImageView.contentMode = .scaleAspectFit
            }
        case .stampsFromJson:
            let imageUrl = stampsFromJson[indexPath.row].thumbnailImageUrl
            cell.pictureImageView.loadFromUrl(imageUrl)
            cell.pictureImageView.contentMode = .scaleAspectFit
        }
        indexPath == selectedIndex ? cell.setState(.selected) : cell.setState(.normal)
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout
extension StampViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = Double(collectionView.bounds.width)
        var itemWidth: Double
        var itemHeight: Double
        if UIDevice.current.orientation.isLandscape {
            itemWidth = collectionWidth/5 - 15
        } else {
            itemWidth = collectionWidth/3 - 15
        }
        itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

// MARK: - CollectionViewDelegate
extension StampViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        selectedCell.setState(.selected)
        selectedIndex = indexPath
        switch type {
        case .stampsFromJson:
            let stamp = Stamp()
            stamp.name = stampsFromJson[indexPath.row].compositionImageFilename
            stamp.thumbnailImageUrl = stampsFromJson[indexPath.row].thumbnailImageUrl
            viewModel.saveStamp(stamp: stamp)
            collectionView.reloadData()
        case .stamps:
            collectionView.reloadData()
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return }
        selectedCell.setState(.normal)
    }
}

// MARK: - CategoryCollectionViewDelegate
extension StampViewController: StampCategoryViewControllerDelegate {
    func fetchStamp(_ categoryViewController: StampCategoryViewController, _ id: Int) {
        if selectedIndex != nil {
            stampCollectionView.deselectItem(at: selectedIndex!, animated: false)
            selectedIndex = nil
        }
        if id == 1 {
            type = .stamps
        } else {
            type = .stampsFromJson
            SVProgressHUD.show(withStatus: Constants.hubLoading.localized)
        }
        viewModel.fetchStamps(with: id)
    }
}

// MARK: - StampViewModelEvents
extension StampViewController: StampViewModelEvents {
    func didUpdateStamp(_ stampViewModel: StampViewModel, _ stamps: Results<Stamp>) {
        self.stamps = stamps.sorted(byKeyPath: "date", ascending: false)
        DispatchQueue.main.async {
            self.stampCollectionView.reloadData()
        }
    }

    func didUpdateStampFromJson(_ stampViewModel: StampViewModel, _ stamps: [StampFromJson]) {
        self.stampsFromJson.removeAll()
        self.stampsFromJson.append(contentsOf: stamps)
        DispatchQueue.main.async {
            self.stampCollectionView.reloadData()
        }
        SVProgressHUD.dismiss()
    }

    func didFailWithError(error: ​ResponseError​) {
        let ac = UIAlertController(title: "Error", message: error.errors, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
        print("Request failed with error: \(error)")
        SVProgressHUD.dismiss()
    }
}
