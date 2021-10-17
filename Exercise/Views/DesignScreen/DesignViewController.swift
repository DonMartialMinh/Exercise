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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DesignViewController {
    static func loadFromNib() -> UIViewController {
        return DesignViewController(nibName: String(describing: self), bundle: nil)
    }
}
