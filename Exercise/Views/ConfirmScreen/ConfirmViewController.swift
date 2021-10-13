//
//  FourViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class ConfirmViewController: UIViewController {

    @IBOutlet weak var confirmProgressView: ProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmProgressView.setState(.confirm)
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

extension ConfirmViewController {
    static func loadFromNib() -> UIViewController {
        return ConfirmViewController(nibName: String(describing: self), bundle: nil)
    }
}
