//
//  CategoryViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/26/21.
//

import UIKit

protocol CategoryViewControllerDelegate: class {
    func fetchStamp(_ categoryViewController: CategoryViewController, _ id: Int)
}

class CategoryViewController: UIViewController {
    private var categories: [Category] = []
    private var selectedCategory: IndexPath? = nil
    private var viewModel = CategoryViewModel()
    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - IBOutlet
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.register(CategoryCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.categoryCellIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.allowsMultipleSelection = false
        viewModel.delegate = self
    }
    
    // MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCategories()
    }

    // MARK: - ViewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDatasource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.categoryCellIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.titleLabel.text = categories[indexPath.row].name
        indexPath == selectedCategory ? cell.setState(.selected) : cell.setState(.normal)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        selectedCell.setState(.selected)
        selectedCategory = indexPath
        delegate?.fetchStamp(self, categories[indexPath.row].id)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        selectedCell.setState(.normal)
    }
}

// MARK: - UICollectionViewFlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = Double(collectionView.bounds.width)
        let collectionHeight = Double(collectionView.bounds.height)
        var itemWidth: Double
        var itemHeight: Double
        itemWidth = collectionWidth/4 - 2
        itemHeight = collectionHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

// MARK: - CategoryViewModelEvents
extension CategoryViewController: CategoryViewModelEvents {
    func didUpdateCategory(_ categoryViewModel: CategoryViewModel, _ categories: [Category]) {
        self.categories.append(contentsOf: categories)
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
        }
    }

    func didFailWithError(error: ​ResponseError​) {
        if error.errors.count != 0 {
            let ac = UIAlertController(title: "Error", message: (error.errors[0].message), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            self.present(ac, animated: true, completion: nil)
            print(
                """
                Request failed with errors:
                    "code": \(error.errors[0].code)
                    "parameter": \(error.errors[0].parameter)
                    "message": \(error.errors[0].message)
                """
            )
        } else {
            let ac = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            self.present(ac, animated: true, completion: nil)
            print("Request failed with error: \(error)")
        }
    }
}
