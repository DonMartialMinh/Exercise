//
//  LibraryViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/14/21.
//

import UIKit
import Photos

class LibraryViewController: UIViewController {
    
    var images = [UIImage]()
    
    @IBOutlet weak var libraryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        libraryCollectionView.register(ImageCollectionViewCell.loadFromNib(), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
        libraryCollectionView.allowsMultipleSelection = false
        getPhotos()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func chooseBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let indexPaths = libraryCollectionView.indexPathsForSelectedItems else { return }
        if indexPaths != [] {
            if let navigationController = presentingViewController as? UINavigationController {
                if let presenter = navigationController.topViewController as? PhotoSelectViewController {
                    let selectedCell = self.libraryCollectionView.cellForItem(at: indexPaths[0]) as! ImageCollectionViewCell
                    presenter.loadedImageView.image = selectedCell.pictureImageView.image
                    selectedCell.setState(.normal)
                    self.libraryCollectionView.deselectItem(at: indexPaths[0], animated: false)
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
    
    fileprivate func getPhotos() {
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        //requestOptions.version = .original
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 200, height: 200)
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.images.append(image)
                        self.libraryCollectionView.reloadData()
                    } else {
                        print("error asset to image")
                    }
                }
            }
        } else {
            print("no photos to display")
        }
        
    }
    
}

//MARK: - UICollectionViewDataSource
extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCellIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.pictureImageView.image = images[indexPath.row]
        return cell
    }
    
    
}

//MARK: - UICollectionViewDelegate
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

//MARK: - UICollectionViewDelegateFlowLayout
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

//MARK: - Extension
extension LibraryViewController {
    static func loadFromNib() -> UIViewController{
        return LibraryViewController(nibName: String(describing: self), bundle: nil)
    }
}
