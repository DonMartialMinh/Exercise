//
//  ProgressView.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/12/21.
//

import UIKit

enum ProgressState {
  case variation
  case photoSelect
  case design
  case confirm
}

class ProgressView: NibView {
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
}
