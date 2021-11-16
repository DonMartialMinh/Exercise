//
//  ProgressView.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/12/21.
//

import UIKit

class ProgressView: NibView {
    var displayScreens: [String:Bool]? {
        didSet {
            setProgressDisplay()
        }
    }
    // MARK: - IBOutlet
    @IBOutlet weak var variationCustomView: CustomView!
    @IBOutlet weak var photoSelectCustomView: CustomView!
    @IBOutlet weak var designCustomView: CustomView!
    @IBOutlet weak var confirmCustomView: CustomView!
    @IBOutlet weak var variationLabel: UILabel!
    @IBOutlet weak var photoSelectLabel: UILabel!
    @IBOutlet weak var designLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var lineStagePhotoSelectView: UIView!
    @IBOutlet weak var lineStageDesignView: UIView!
    @IBOutlet weak var lineStageConfirmView: UIView!
    @IBOutlet weak var outerLineStageSelectView: UIView!
    @IBOutlet weak var outerLineStageDesignView: UIView!
    @IBOutlet weak var outerLineStageConfirmView: UIView!
    
    // MARK: - SetState
    func setState (_ state: ProgressState) {
        switch state {
        case .variation:
            variationCustomView.color = UIColor.red
            variationLabel.textColor = UIColor.black
        case .photoSelect:
            variationCustomView.color = UIColor.white
            variationCustomView.borderWidth = 1
            variationCustomView.borderColor = UIColor.red
            lineStagePhotoSelectView.backgroundColor = UIColor.red
            photoSelectCustomView.color = UIColor.red
            photoSelectLabel.textColor = UIColor.black
        case .design:
            variationCustomView.color = UIColor.white
            variationCustomView.borderWidth = 1
            variationCustomView.borderColor = UIColor.red
            lineStagePhotoSelectView.backgroundColor = UIColor.red
            photoSelectCustomView.color = UIColor.white
            photoSelectCustomView.borderWidth = 1
            photoSelectCustomView.borderColor = UIColor.red
            lineStageDesignView.backgroundColor = UIColor.red
            designCustomView.color = UIColor.red
            designLabel.textColor = UIColor.black
        case .confirm:
            variationCustomView.color = UIColor.white
            variationCustomView.borderWidth = 1
            variationCustomView.borderColor = UIColor.red
            lineStagePhotoSelectView.backgroundColor = UIColor.red
            photoSelectCustomView.color = UIColor.white
            photoSelectCustomView.borderWidth = 1
            photoSelectCustomView.borderColor = UIColor.red
            lineStageDesignView.backgroundColor = UIColor.red
            designCustomView.color = UIColor.white
            designCustomView.borderWidth = 1
            designCustomView.borderColor = UIColor.red
            lineStageConfirmView.backgroundColor = UIColor.red
            confirmCustomView.color = UIColor.red
            confirmLabel.textColor = UIColor.black
        }
    }

    func setProgressDisplay() {
        if displayScreens![VariationViewController.classId] == false {
            variationCustomView.isHidden = true
            variationLabel.isHidden = true
            lineStagePhotoSelectView.isHidden = true
            outerLineStageSelectView.isHidden = true
        }
        if displayScreens![PhotoSelectViewController.classId] == false {
            photoSelectCustomView.isHidden = true
            photoSelectLabel.isHidden = true
            lineStageDesignView.isHidden = true
            outerLineStageDesignView.isHidden = true
        }
    }
}
