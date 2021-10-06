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
    var rightBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLeftBarButton()
        setup()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func previousBarButtonItemPressed(_ sender: UIBarButtonItem) {
        goToPreviousPage()
    }
    
    func setup() {
        delegate = self
        dataSource = self
        let firstView = FirstViewController(nibName: "FirstViewController", bundle: nil)
        let secondView = FirstViewController(nibName: "SecondViewController", bundle: nil)
        let thirdView = FirstViewController(nibName: "ThirdViewController", bundle: nil)
        let fourView = FirstViewController(nibName: "FourViewController", bundle: nil)
        
        pages.append(firstView)
        pages.append(secondView)
        pages.append(thirdView)
        pages.append(fourView)
        setViewControllers([pages[initialView]], direction: .forward, animated: true, completion: nil)
    }
    
    func createLeftBarButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 35))
        button.setTitle("次へ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = UIColor(named: "orange")
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
        rightBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func didTapRightBarButton(sender: UIButton!) {
        goToNextPage()
    }
    
}

extension EnvelopePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil             // wrap to last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return nil              // wrap to first
        }
    }
}


extension EnvelopePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}

extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .reverse, animated: animated, completion: completion)
    }
}
