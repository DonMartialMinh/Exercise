//
//  EnvelopePageViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class EnvelopePageViewController: UIPageViewController{
    
    var pages = [UIViewController]()
    let initialView = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    func setup() {
//        delegate = self
//        dataSource = self
        let firstView = FirstViewController(nibName: "FirstViewController", bundle: nil)
        pages.append(firstView)
        setViewControllers([pages[initialView]], direction: .forward, animated: true, completion: nil)
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

//extension EnvelopePageViewController: UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
//
//        if currentIndex == 0 {
//            return pages.last               // wrap to last
//        } else {
//            return pages[currentIndex - 1]  // go previous
//        }
//    }
//
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
//
//        if currentIndex < pages.count - 1 {
//            return pages[currentIndex + 1]  // go next
//        } else {
//            return pages.first              // wrap to first
//        }
//    }
//}
//
//
//extension EnvelopePageViewController: UIPageViewControllerDelegate {
//
//}
