//
//  SecondViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class PhotoSelectViewController: UIViewController {
    @IBOutlet weak var photoSelectProgressView: ProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoSelectProgressView.setState(.photoSelect)
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

extension PhotoSelectViewController {
    static func loadFromNib() -> UIViewController {
        return PhotoSelectViewController(nibName: String(describing: self), bundle: nil)
    }
}
