//
//  FourViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class ConfirmViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var confirmProgressView: ProgressView!
    @IBOutlet weak var pictureFrameView: PictureFrame!

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmProgressView.setState(.confirm)
        pictureFrameView.setColor(.lightGreen)
        // Do any additional setup after loading the view.
    }
}
