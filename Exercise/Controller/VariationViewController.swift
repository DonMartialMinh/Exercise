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
    @IBOutlet weak var variationProgressView: ProgressView!
    
    lazy var photoSelectViewController  = PhotoSelectViewController.loadFromNib()
    lazy var designViewController  = DesignViewController.loadFromNib()
    lazy var confirmViewController  = ConfirmViewController.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        navigationController?.navigationBar.delegate = self
        variationProgressView.setState(.variation)
        initializeBarButton()
        shadowNavigationBar()
    }
    
    func initializeBarButton() {
        let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 35))
        nextButton.setTitle(Constants.nextBarButtonTitle.localized, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
        nextButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        nextButton.titleLabel?.textAlignment = .center
        nextButton.backgroundColor = UIColor.appColor(.orange)
        nextButton.layer.cornerRadius = 5.0
        nextButton.addTarget(self, action: #selector(didTapNextBarButton), for: .touchUpInside)
        nextBarButton.customView = nextButton
        
        let backButton = UIButton(type: .system)
        backButton.setTitle(Constants.backBarButtonTittle.localized, for: .normal)
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
        let title = navigationItem.title!.localized
        if title == Constants.NavigationTitle.confirm.localized { return }
        if title == Constants.NavigationTitle.variation.localized {
            navigationController?.pushViewController(photoSelectViewController, animated: true)
        } else if title == Constants.NavigationTitle.photoSelect.localized {
            navigationController?.pushViewController(designViewController, animated: true)
        } else if title == Constants.NavigationTitle.design.localized {
            navigationController?.pushViewController(confirmViewController, animated: true)
        }
        changeNavigationItemForward(with: title)
    }
    
    private func changeNavigationItemForward(with title: String)  {
        let nextButton = nextBarButton.customView as! UIButton
        let backButton = backBarButton.customView as! UIButton
        if title == Constants.NavigationTitle.variation.localized {
            navigationItem.title = Constants.NavigationTitle.photoSelect.localized
            nextButton.setTitle(Constants.nextBarButtonTitle.localized, for: .normal)
        } else if title == Constants.NavigationTitle.photoSelect.localized {
            navigationItem.title = Constants.NavigationTitle.design.localized
            nextButton.setTitle(Constants.nextBarButtonTitle.localized, for: .normal)
        } else if title == Constants.NavigationTitle.design.localized {
            navigationItem.title = Constants.NavigationTitle.confirm.localized
            nextButton.setTitle(Constants.nextBarButtonEndTitle.localized, for: .normal)
        }
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    }
    
    private func changeNavigationItemBackward(with title: String)  {
        let nextButton = nextBarButton.customView as! UIButton
        let backButton = backBarButton.customView as! UIButton
        if title == Constants.NavigationTitle.photoSelect.localized {
            navigationItem.title = Constants.NavigationTitle.variation.localized
            nextButton.setTitle(Constants.nextBarButtonTitle.localized, for: .normal)
            backButton.setImage(nil, for: .normal)
        } else if title == Constants.NavigationTitle.design.localized {
            navigationItem.title = Constants.NavigationTitle.photoSelect.localized
            nextButton.setTitle(Constants.nextBarButtonTitle.localized, for: .normal)
        } else if title == Constants.NavigationTitle.confirm.localized {
            navigationItem.title = Constants.NavigationTitle.design.localized
            nextButton.setTitle(Constants.nextBarButtonTitle.localized, for: .normal)
        }
    }
    
}

extension VariationViewController: UINavigationBarDelegate {
    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        return false
    }
}
