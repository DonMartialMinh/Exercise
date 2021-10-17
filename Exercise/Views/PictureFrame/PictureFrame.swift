//
//  PictureFrame.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/17/21.
//

import UIKit

class PictureFrame: NibView {
    @IBOutlet weak var topFrameView: UIView!
    @IBOutlet weak var rightFrameView: UIView!
    @IBOutlet weak var leftFrameView: UIView!
    @IBOutlet weak var bottomFrameView: UIView!
    
    func setColor(_ color: AssetsColor) {
        topFrameView.backgroundColor = UIColor.appColor(color)
        leftFrameView.backgroundColor = UIColor.appColor(color)
        bottomFrameView.backgroundColor = UIColor.appColor(color)
        rightFrameView.backgroundColor = UIColor.appColor(color)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
