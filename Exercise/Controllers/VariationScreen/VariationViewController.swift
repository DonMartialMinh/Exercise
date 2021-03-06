//
//  MainViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/11/21.
//

import UIKit

class VariationViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var variationProgressView: ProgressView!
    @IBOutlet weak var pictureFrameView: PictureFrame!

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - SetUp
    func setup() {
        variationProgressView.setState(.variation)
        pictureFrameView.setColor(.purple)
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        let button = navigationItem.leftBarButtonItem?.customView as! UIButton
        button.setImage(nil, for: .normal)
    }

    // MARK: - ButtonClicked
    override func nextButtonClicked(_ sender: UIBarButtonItem) {
        let photoSelectVC = PhotoSelectViewController.initFromNib()
        navigationController?.pushViewController(photoSelectVC, animated: true)
    }
}
