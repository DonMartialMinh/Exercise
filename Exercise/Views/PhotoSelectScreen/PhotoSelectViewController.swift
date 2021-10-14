//
//  SecondViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit
import Photos

class PhotoSelectViewController: UIViewController {
    @IBOutlet weak var loadedImageView: UIImageView!
    @IBOutlet weak var photoSelectProgressView: ProgressView!
    
    lazy var libraryViewController = LibraryViewController.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoSelectProgressView.setState(.photoSelect)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editPhotoButtonPressed(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if status == .authorized{
                    self.libraryViewController.modalPresentationStyle = .fullScreen
                    self.present(self.libraryViewController, animated: true, completion: nil)
                } else {
                    let ac = UIAlertController(title: "Enable photos access?", message: "To use this feature you must enable photos access in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString)  else {
                            return
                        }
                        if (UIApplication.shared.canOpenURL(settingsUrl)) {
                            UIApplication.shared.open(settingsUrl, completionHandler: nil)
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension PhotoSelectViewController {
    static func loadFromNib() -> UIViewController {
        return PhotoSelectViewController(nibName: String(describing: self), bundle: nil)
    }
}
