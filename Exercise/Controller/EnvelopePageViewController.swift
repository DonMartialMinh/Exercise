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
    let navigationTitle = Constants.navigationTitle
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set up
    func setup() {
        delegate = self
        dataSource = self
        initializeRightBarButton()
        let firstView = FirstViewController(nibName: Constants.firstScreenIdentifier, bundle: nil)
        let secondView = FirstViewController(nibName: Constants.secondScreenIdentifier, bundle: nil)
        let thirdView = FirstViewController(nibName: Constants.thirdScreenIdentifier, bundle: nil)
        let fourView = FirstViewController(nibName: Constants.fourScreenIdentifier, bundle: nil)
        pages.append(firstView)
        pages.append(secondView)
        pages.append(thirdView)
        pages.append(fourView)
        setViewControllers([pages[initialView]], direction: .forward, animated: true, completion: nil)
    }
    
    func initializeRightBarButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 35))
        button.setTitle(Constants.rightBarButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor(named: Constants.Color.orange)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
        rightBarButton.customView = button
    }
    
    //MARK: - Page navigation
    @IBAction func previousBarButtonItemPressed(_ sender: UIBarButtonItem) {
        goToPreviousPage()
    }
    
    @objc func didTapRightBarButton(sender: UIButton!) {
        goToNextPage()
    }
    
}

//MARK: - UIpageViewControllerDataSource
extension EnvelopePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}

//MARK: - UIPageViewControllerDelegate
extension EnvelopePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        changeNavigationItem(with: currentIndex)
    }
    
    private func changeNavigationItem(with index: Int)  {
        let isLastPage = index == pages.count - 1
        navigationItem.title = navigationTitle[index]
        let button = rightBarButton.customView as! UIButton
        if isLastPage {
            button.setTitle(Constants.rightBarButtonEndTitle, for: .normal)
        } else {
            button.setTitle(Constants.rightBarButtonTitle, for: .normal)
        }
    }
}

//MARK: - UIPageViewController Navigation
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
