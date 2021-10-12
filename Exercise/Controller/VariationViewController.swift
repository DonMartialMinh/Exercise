//
//  MainViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/11/21.
//

import UIKit

class VariationViewController: UIViewController {
    
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    @IBOutlet weak var backBarButton: UIBarButtonItem!

    lazy var photoSelectViewController  = UIViewController.appViewController(.photoSelectViewController)
    lazy var designViewController  = UIViewController.appViewController(.designViewController)
    lazy var confirmViewController  = UIViewController.appViewController(.confirmViewController)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        navigationController?.navigationBar.delegate = self
        initializeBarButton()
        shadowNavigationBar()
    }
    
    func initializeBarButton() {
        let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 35))
        nextButton.setTitle(Constants.nextBarButtonTitle, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
        nextButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        nextButton.titleLabel?.textAlignment = .center
        nextButton.backgroundColor = UIColor.appColor(.orange)
        nextButton.layer.cornerRadius = 5.0
        nextButton.addTarget(self, action: #selector(didTapNextBarButton), for: .touchUpInside)
        nextBarButton.customView = nextButton
        
        let backButton = UIButton(type: .system)
        backButton.setTitle(Constants.backBarButtonTittle, for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        backButton.titleLabel?.textAlignment = .center
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = UIColor.black
        backButton.addTarget(self, action: #selector(didTapBackBarButton), for: .touchUpInside)
        backBarButton.customView = backButton
    }
    
    func shadowNavigationBar(){
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
    
    @objc func didTapBackBarButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        changeNavigationItemBackward(with: navigationItem.title!)
    }
    
    @objc func didTapNextBarButton(sender: UIButton!) {
        let title = navigationItem.title!
        if title == Constants.NavigationTitle.confirm { return }
        if title == Constants.NavigationTitle.variation {
            navigationController?.pushViewController(photoSelectViewController, animated: true)
        } else if title == Constants.NavigationTitle.photoSelect {
            navigationController?.pushViewController(designViewController, animated: true)
        } else if title == Constants.NavigationTitle.design {
            navigationController?.pushViewController(confirmViewController, animated: true)
        }
        changeNavigationItemForward(with: title)
    }
    
    private func changeNavigationItemForward(with title: String)  {
        let nextButton = nextBarButton.customView as! UIButton
        let backButton = backBarButton.customView as! UIButton
        if title == Constants.NavigationTitle.variation {
            navigationItem.title = Constants.NavigationTitle.photoSelect
            nextButton.setTitle(Constants.nextBarButtonTitle, for: .normal)
        } else if title == Constants.NavigationTitle.photoSelect {
            navigationItem.title = Constants.NavigationTitle.design
            nextButton.setTitle(Constants.nextBarButtonTitle, for: .normal)
        } else if title == Constants.NavigationTitle.design {
            navigationItem.title = Constants.NavigationTitle.confirm
            nextButton.setTitle(Constants.nextBarButtonEndTitle, for: .normal)
        }
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    }
    
    private func changeNavigationItemBackward(with title: String)  {
        let nextButton = nextBarButton.customView as! UIButton
        let backButton = backBarButton.customView as! UIButton
        if title == Constants.NavigationTitle.photoSelect {
            navigationItem.title = Constants.NavigationTitle.variation
            nextButton.setTitle(Constants.nextBarButtonTitle, for: .normal)
            backButton.setImage(nil, for: .normal)
        } else if title == Constants.NavigationTitle.design {
            navigationItem.title = Constants.NavigationTitle.photoSelect
            nextButton.setTitle(Constants.nextBarButtonTitle, for: .normal)
        } else if title == Constants.NavigationTitle.confirm {
            navigationItem.title = Constants.NavigationTitle.design
            nextButton.setTitle(Constants.nextBarButtonTitle, for: .normal)
        }
    }
    
}

extension VariationViewController: UINavigationBarDelegate {
    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        return false
    }
}
