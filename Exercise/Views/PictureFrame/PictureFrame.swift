//
//  PictureFrame.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/17/21.
//

import UIKit

class PictureFrame: NibView {
    // MARK: - IBOutlet
    @IBOutlet weak var topFrameView: UIView!
    @IBOutlet weak var rightFrameView: UIView!
    @IBOutlet weak var leftFrameView: UIView!
    @IBOutlet weak var bottomFrameView: UIView!

    // MARK: - SetColor
    func setColor(_ color: AssetsColor) {
        topFrameView.backgroundColor = UIColor.appColor(color)
        leftFrameView.backgroundColor = UIColor.appColor(color)
        bottomFrameView.backgroundColor = UIColor.appColor(color)
        rightFrameView.backgroundColor = UIColor.appColor(color)
    }
}
