//
//  VariationViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 11/16/21.
//

import UIKit

class VariationViewController: BaseViewController {
    var template: Template?
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
        variationProgressView.template = template
        variationProgressView.setState(.variation)
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        let button = navigationItem.leftBarButtonItem?.customView as! UIButton
        button.setImage(nil, for: .normal)
    }

    // MARK: - ButtonClicked
    override func nextButtonClicked(_ sender: UIBarButtonItem) {
        guard let template = template,
              let isPhotoSelect = template.isPhotoSelect()
        else { return }
        if isPhotoSelect {
            let photoSelectVC = PhotoSelectViewController.initFromNib()
            photoSelectVC.template = template
            navigationController?.pushViewController(photoSelectVC, animated: true)
        } else {
            let designVC = DesignViewController.initFromNib()
            designVC.template = template
            navigationController?.pushViewController(designVC, animated: true)
        }
        
    }
}
