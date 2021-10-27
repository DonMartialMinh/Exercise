//
//  StampViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/26/21.
//

import UIKit
import SVProgressHUD

class StampViewController: UIViewController {
    private var stamps: [Stamp] = []

    // MARK: - IBOutlet
    @IBOutlet weak var stampCollectionView: UICollectionView!

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        stampCollectionView.register(ImageCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
        stampCollectionView.delegate = self
        stampCollectionView.dataSource = self
        stampCollectionView.allowsMultipleSelection = false
    }

    // MARK: - ViewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = stampCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }

    // MARK: - fetchData
    func fetchStamps(with id: Int) {
        SVProgressHUD.show(withStatus: Constants.hubLoading.localized)
        APIManager.shared.fetchStamps(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stamps):
                self.stamps.removeAll()
                self.stamps.append(contentsOf: stamps!.data)
                DispatchQueue.main.async {
                    self.stampCollectionView.reloadData()
                }
                SVProgressHUD.dismiss()
            case .failure(let error):
                print("Request failed with error \(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDatasource
extension StampViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stamps.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCellIdentifier, for: indexPath) as! ImageCollectionViewCell
        let imageUrl = stamps[indexPath.row].thumbnailImageUrl
        cell.pictureImageView.loadFromUrl(imageUrl)
        cell.pictureImageView.contentMode = .scaleAspectFit
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

// MARK: - CategoryCollectionViewDelegate
extension StampViewController: CategoryViewControllerDelegate {
    func didUpdateStamp(_ categoryViewController: CategoryViewController, _ id: Int) {
        fetchStamps(with: id)
    }
}
