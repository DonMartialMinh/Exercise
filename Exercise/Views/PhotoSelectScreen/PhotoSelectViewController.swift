//
//  SecondViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit
import Photos

class PhotoSelectViewController: BaseViewController {
  // MARK: - IBOutlet
  @IBOutlet weak var loadedImageView: UIImageView!
  @IBOutlet weak var photoSelectProgressView: ProgressView!
  @IBOutlet weak var pictureFrameView: PictureFrame!

  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    photoSelectProgressView.setState(.photoSelect)
    pictureFrameView.setColor(.purple)
    navigationItem.title = Constants.NavigationTitle.photoSelect.localized
  }

  // MARK: - ButtonClicked
  override func nextButtonClicked(_ sender: UIBarButtonItem) {
    let designVC  = DesignViewController.initFromNib()
    navigationController?.pushViewController(designVC, animated: true)
  }

  @IBAction func editPhotoButtonPressed(_ sender: UIButton) {
    PHPhotoLibrary.requestAuthorization { (status) in
      DispatchQueue.main.async {
        if status == .authorized{
          let libraryVC = LibraryViewController.initFromNib()
          libraryVC.delegate = self
          libraryVC.modalPresentationStyle = .fullScreen
          self.present(libraryVC, animated: true, completion: nil)
        } else {
          let ac = UIAlertController(title: Constants.Alert.photoAccessTitle.localized, message: Constants.Alert.photoAccessMessage.localized, preferredStyle: .alert)
          let goToSettings = UIAlertAction(title: Constants.Alert.settings.localized, style: .default) { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString)  else {
              return
            }
            if (UIApplication.shared.canOpenURL(settingsUrl)) {
              UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
          }
          ac.addAction(goToSettings)
          ac.addAction(UIAlertAction(title: Constants.Alert.cancel.localized, style: .cancel, handler: nil))
          self.present(ac, animated: true, completion: nil)
        }
      }
    }
  }
}

// MARK: - LibraryViewControllerDelegate
extension PhotoSelectViewController: LibraryViewControllerDelegate {
  func didUpdateImage(_ libraryViewController: LibraryViewController, _ image: UIImage) {
    loadedImageView.image = image
  }
}
