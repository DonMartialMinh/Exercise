//
//  FourViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class ConfirmViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var confirmProgressView: ProgressView!
    @IBOutlet weak var pictureFrameView: PictureFrame!

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmProgressView.setState(.confirm)
        pictureFrameView.setColor(.lightGreen)
        navigationItem.title = Constants.NavigationTitle.confirm.localized
        // Do any additional setup after loading the view.
    }

    // MARK: - ConfigureNavigationBar
    override func configureNavigationBar() {
        super.configureNavigationBar()
        let button = navigationItem.rightBarButtonItem?.customView as! UIButton
        button.setTitle(Constants.nextBarButtonEndTitle.localized, for: .normal)
    }
}
