//
//  LibraryViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/14/21.
//

import UIKit
import Photos

class LibraryViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var libraryCollectionView: UICollectionView!
    var allPhotos = PHFetchResult<PHAsset>()

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        libraryCollectionView.register(ImageCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
        libraryCollectionView.allowsMultipleSelection = false
        PHPhotoLibrary.shared().register(self)
        getPhotos()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = libraryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }

    fileprivate func getPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }

    // MARK: - ButtonCLicked
    @IBAction func chooseBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let indexPaths = libraryCollectionView.indexPathsForSelectedItems else { return }
        if indexPaths != [] {
            if let navigationController = presentingViewController as? UINavigationController {
                if let presenter = navigationController.topViewController as? PhotoSelectViewController {
                    let selectedCell = libraryCollectionView.cellForItem(at: indexPaths[0]) as! ImageCollectionViewCell
                    presenter.loadedImageView.image = selectedCell.pictureImageView.image
                    selectedCell.setState(.normal)
                    libraryCollectionView.deselectItem(at: indexPaths[0], animated: false)
                }
            }
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let indexPaths = libraryCollectionView.indexPathsForSelectedItems else { return }
        if indexPaths != [] {
            let ac = UIAlertController(title: Constants.Alert.unselectImageTitle.localized, message: Constants.Alert.unselectImageMessage.localized, preferredStyle: .alert)
            let goBack = UIAlertAction(title: Constants.Alert.goBack.localized, style: .default) { (_) in
                let selectedCell = self.libraryCollectionView.cellForItem(at: indexPaths[0]) as! ImageCollectionViewCell
                selectedCell.setState(.normal)
                self.libraryCollectionView.deselectItem(at: indexPaths[0], animated: false)
                self.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: Constants.Alert.cancel.localized, style: .cancel, handler: nil)
            ac.addAction(goBack)
            ac.addAction(cancel)
            present(ac, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCellIdentifier, for: indexPath) as! ImageCollectionViewCell
        let asset = allPhotos.object(at: indexPath.row)
        cell.pictureImageView.fetchImage(asset: asset, targetSize: cell.pictureImageView.frame.size, contentMode: .aspectFit)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        selectedCell.setState(.selected)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        selectedCell.setState(.normal)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LibraryViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - PHPhotoLibraryChangeObserver
extension LibraryViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let collectionView = self.libraryCollectionView else { return }
        DispatchQueue.main.sync {
            if let changes = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changes.fetchResultAfterChanges
                if changes.hasIncrementalChanges {
                    collectionView.performBatchUpdates({
                        if let removed = changes.removedIndexes, removed.count > 0 {
                            collectionView.deleteItems(at: removed.map { IndexPath(item: $0, section:0) })
                        }
                        if let inserted = changes.insertedIndexes, inserted.count > 0 {
                            collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
                        }
                        if let changed = changes.changedIndexes, changed.count > 0 {
                            collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
                        }
                        changes.enumerateMoves { fromIndex, toIndex in
                            collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                    to: IndexPath(item: toIndex, section: 0))
                        }
                    })
                } else {
                    collectionView.reloadData()
                }
            }
        }
    }
}
