//
//  VariationViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/16/21.
//

import UIKit

class VariationViewController: BaseViewController {
    var displayScreens: [String:Bool] = [:]
    // MARK: - IBOutlet
    @IBOutlet weak var variationProgressView: ProgressView!
    @IBOutlet weak var pictureFrameView: PictureFrame!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - SetUp
    func setup() {
        setProgressView()
        navigationItem.title = Constants.NavigationTitle.variation.localized
        pictureFrameView.setColor(.purple)
    }
    
    func setProgressView(){
        variationProgressView.displayScreens = displayScreens
        variationProgressView.setState(.variation)
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        let button = navigationItem.leftBarButtonItem?.customView as! UIButton
        button.setImage(nil, for: .normal)
    }

    // MARK: - ButtonClicked
    override func nextButtonClicked(_ sender: UIBarButtonItem) {
        if displayScreens[PhotoSelectViewController.classId] == true {
            let photoSelectVC = PhotoSelectViewController.initFromNib()
            photoSelectVC.displayScreens = displayScreens
            navigationController?.pushViewController(photoSelectVC, animated: true)
        } else {
            let designVC = DesignViewController.initFromNib()
            designVC.displayScreens = displayScreens
            navigationController?.pushViewController(designVC, animated: true)
        }
        
    }
}
