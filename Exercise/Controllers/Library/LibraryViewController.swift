//
//  LibraryViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/14/21.
//

import UIKit
import Photos

protocol LibraryViewControllerDelegate: class {
    func didUpdateImage(_ libraryViewController: LibraryViewController, _ image: UIImage)
}

class LibraryViewController: UIViewController {
    private var allPhotos = PHFetchResult<PHAsset>()
    private var selectedIndex: IndexPath? = nil
    private var viewModel = LibraryViewModel()
    weak var delegate: LibraryViewControllerDelegate?

    // MARK: - IBOutlet
    @IBOutlet weak var libraryCollectionView: UICollectionView!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        libraryCollectionView.register(ImageCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
        libraryCollectionView.allowsMultipleSelection = false
        PHPhotoLibrary.shared().register(self)
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPhotos()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = libraryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }

    // MARK: - ButtonCLicked
    @IBAction func chooseBarButtonPressed(_ sender: UIBarButtonItem) {
        if selectedIndex != nil {
            guard let selectedCell = libraryCollectionView.dataSource?.collectionView(libraryCollectionView, cellForItemAt: selectedIndex!) as? ImageCollectionViewCell,
                  let image = selectedCell.pictureImageView.image
            else { return }
            delegate?.didUpdateImage(self, image)
            selectedCell.setState(.normal)
            libraryCollectionView.deselectItem(at: selectedIndex!, animated: false)
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        if selectedIndex != nil {
            let ac = UIAlertController(title: Constants.Alert.unselectImageTitle.localized, message: Constants.Alert.unselectImageMessage.localized, preferredStyle: .alert)
            let goBack = UIAlertAction(title: Constants.Alert.goBack.localized, style: .default) { (_) in
                guard let selectedCell = self.libraryCollectionView.dataSource?.collectionView(self.libraryCollectionView, cellForItemAt: self.selectedIndex!) as? ImageCollectionViewCell else { return }
                selectedCell.setState(.normal)
                self.libraryCollectionView.deselectItem(at: self.selectedIndex!, animated: false)
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
        indexPath == selectedIndex ? cell.setState(.selected) : cell.setState(.normal)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        selectedCell.setState(.selected)
        selectedIndex = indexPath
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return }
        selectedCell.setState(.normal)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = Double(collectionView.bounds.width)
        var itemWidth: Double
        if UIDevice.current.orientation.isLandscape {
            itemWidth = collectionWidth/5 - 2
        } else {
            itemWidth = collectionWidth/3 - 2
        }
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

// MARK: - PhotoViewModelEvents
extension LibraryViewController: LibraryViewModelEvents {
    func didUpdatePhoto(_ photoViewModel: LibraryViewModel, _ photos: PHFetchResult<PHAsset>) {
        allPhotos = photos
    }
}
