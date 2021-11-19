//
//  ThirdViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class DesignViewController: BaseViewController {
    var displayScreens: [String:Bool] = [:]
    // MARK: - IBOutlet
    @IBOutlet weak var designProgressView: ProgressView!
    @IBOutlet weak var pictureFrameView: PictureFrame!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setProgressView()
        pictureFrameView.setColor(.purple)
        navigationItem.title = Constants.NavigationTitle.design.localized
    }

    func setProgressView(){
        designProgressView.setState(.design)
        designProgressView.displayScreens = displayScreens
    }

    // MARK: - Button Clicked
    override func nextButtonClicked(_ sender: UIBarButtonItem) {
        let confirmVC = ConfirmViewController.initFromNib()
        confirmVC.displayScreens = displayScreens
        navigationController?.pushViewController(confirmVC, animated: true)
    }

    @IBAction func stampTaped(_ sender: UITapGestureRecognizer) {
        let stampCollectionVC = StampCollectionViewController.initFromNib()
        stampCollectionVC.modalPresentationStyle = .fullScreen
        present(stampCollectionVC, animated: true, completion: nil)
    }
}
