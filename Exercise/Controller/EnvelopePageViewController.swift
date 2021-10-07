//
//  EnvelopePageViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/6/21.
//

import UIKit

class EnvelopePageViewController: UIPageViewController{
    
    var pages = [UIViewController]()
    let navigationTitle = ["バリエーションを選択", "配置したい写真を選択", "デザイン・差出人の編集", "デザインを最終確認"]
    let initialView = 0
    var rightBarButton = UIBarButtonItem()
    
    private var leftFloatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.setBackgroundImage(UIImage(named: "sample_btn"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 7
        return button
    }()
    
    private var rightFloatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        button.setBackgroundImage(UIImage(named: "enlargement_btn"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 7
        return button
    }()
    
    private var helpFloatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setBackgroundImage(UIImage(named: "help"), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        leftFloatingButton.frame = CGRect(x: 20, y: view.frame.size.height - 200, width: 70, height: 70)
        
        rightFloatingButton.frame = CGRect(x: view.frame.size.width - 20 - 70, y: view.frame.size.height - 200, width: 70, height: 70)
        
        helpFloatingButton.frame = CGRect(x: view.frame.size.width - 20 - 30, y: 120, width: 30, height: 30)
    }
    
    
    func setup() {
        delegate = self
        dataSource = self
        view.addSubview(leftFloatingButton)
        view.addSubview(rightFloatingButton)
        view.addSubview(helpFloatingButton)
        initializeRightBarButton()
        navigationItem.rightBarButtonItem = rightBarButton
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
    
    func initializeRightBarButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 35))
        button.setTitle("次へ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = UIColor(named: "orange")
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
        rightBarButton = UIBarButtonItem(customView: button)
    }
    
    @IBAction func previousBarButtonItemPressed(_ sender: UIBarButtonItem) {
        goToPreviousPage()
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
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        hideButtonsIfNeeded(with: currentIndex)
        changeNavigationItem(with: currentIndex)
    }
    
    private func hideButtonsIfNeeded(with index: Int)  {
        let isLastPage = index == pages.count - 1
        if isLastPage {
            hideButtons()
        } else {
            showButtons()
        }
    }
    
    private func changeNavigationItem(with index: Int)  {
        let isLastPage = index == pages.count - 1
        navigationItem.title = navigationTitle[index]
        if isLastPage {
            rightBarButton.title = "注文へ 進む"
        } else {
            rightBarButton.title = "次へ"
        }
    }
    
    private func hideButtons() {
        leftFloatingButton.isHidden = true
        rightFloatingButton.isHidden = true
    }
    
    private func showButtons() {
        leftFloatingButton.isHidden = false
        rightFloatingButton.isHidden = false
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
