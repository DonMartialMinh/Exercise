//
//  StampCollectionViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import UIKit

class StampCollectionViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var stampCollectionView: UICollectionView!
    var stamps = [Stamp]()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        stampCollectionView.register(ImageCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
        stampCollectionView.delegate = self
        stampCollectionView.dataSource = self
        stampCollectionView.allowsMultipleSelection = false
        fetchStamps()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = stampCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    // MARK: - ButtonPressed
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - fetchStamps
    func fetchStamps() {
        APIManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let stamps):
                self.stamps = stamps!.data
                DispatchQueue.main.async {
                    self.stampCollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error \(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDatasource
extension StampCollectionViewController: UICollectionViewDataSource {
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

// MARK: - UICollectionViewDelegate
extension StampCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewFlowLayout
extension StampCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let itemWidth = collectionWidth/3  - 2
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
