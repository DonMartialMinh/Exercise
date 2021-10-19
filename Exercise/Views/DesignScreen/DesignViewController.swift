//
//  ThirdViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class DesignViewController: UIViewController {

    @IBOutlet weak var designProgressView: ProgressView!
    @IBOutlet weak var pictureFrameView: PictureFrame!

    override func viewDidLoad() {
        super.viewDidLoad()
        designProgressView.setState(.design)
        pictureFrameView.setColor(.purple)
        // Do any additional setup after loading the view.
    }
}
