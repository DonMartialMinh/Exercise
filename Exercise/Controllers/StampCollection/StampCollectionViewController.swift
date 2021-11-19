//
//  StampCollectionViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import UIKit

class StampCollectionViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var stampView: UIView!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    // MARK: - SetUp
    func setUp() {
        let categoryViewController = StampCategoryViewController()
        let stampViewController = StampViewController()
        categoryViewController.delegate = stampViewController
        addChild(categoryViewController)
        addChild(stampViewController)
        categoryView.addSubview(categoryViewController.view)
        stampView.addSubview(stampViewController.view)
        categoryViewController.didMove(toParent: self)
        stampViewController.didMove(toParent: self)
        categoryViewController.view.frame = categoryView.bounds
        stampViewController.view.frame = stampView.bounds
    }

    // MARK: - ButtonPressed
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
