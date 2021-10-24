//
//  BaseViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/19/21.
//

import UIKit

class BaseViewController: UIViewController {
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
  }

  // MARK: - ConfigureNavigationBar
  func configureNavigationBar() {
    //shadow navigation bar
    self.navigationController?.navigationBar.layer.masksToBounds = false
    self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
    self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
    self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
    self.navigationController?.navigationBar.layer.shadowRadius = 2
    //create bar button item
    let backButton = UIButton(type: .system)
    backButton.setTitle(Constants.backBarButtonTittle.localized, for: .normal)
    backButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
    backButton.titleLabel?.textAlignment = .center
    backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    backButton.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
    let LeftButton = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = LeftButton
    let Button = UIButton(frame: CGRect(x: 0, y: 0, width: 52, height: 35))
    Button.setTitle(Constants.nextBarButtonTitle.localized, for: .normal)
    Button.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
    Button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
    Button.titleLabel?.textAlignment = .center
    Button.backgroundColor = UIColor.appColor(.orange)
    Button.layer.cornerRadius = 5.0
    Button.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    let rightButton = UIBarButtonItem(customView: Button)
    navigationItem.rightBarButtonItem = rightButton
  }

  // MARK: - ButtonClicked
  @objc func leftButtonClicked(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  @objc func nextButtonClicked(_ sender: UIBarButtonItem) {}
}
