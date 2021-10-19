//
//  ThirdViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class DesignViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var designProgressView: ProgressView!
    @IBOutlet weak var pictureFrameView: PictureFrame!

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        designProgressView.setState(.design)
        pictureFrameView.setColor(.purple)
        navigationItem.title = Constants.NavigationTitle.design.localized
        // Do any additional setup after loading the view.
    }

    // MARK: - Button Clicked
    override func nextButtonClicked(_ sender: UIBarButtonItem) {
        let confirmVC = ConfirmViewController.initFromNib()
        navigationController?.pushViewController(confirmVC, animated: true)
    }
}
