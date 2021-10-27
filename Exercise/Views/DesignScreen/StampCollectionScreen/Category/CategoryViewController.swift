//
//  CategoryViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/26/21.
//

import UIKit

protocol CategoryViewControllerDelegate: class {
    func didUpdateStamp(_ categoryViewController: CategoryViewController, _ id: Int)
}

class CategoryViewController: UIViewController {
    private var categories: [Category] = []
    private var selectedCategory: IndexPath? = nil
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
        fetchCategories()
    }

    // MARK: - ViewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }

    // MARK: - fetchData
    func fetchCategories() {
        APIManager.shared.fetchCategories { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categories.append(contentsOf: categories!.data)
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error \(error)")
            }
        }
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
        delegate?.didUpdateStamp(self, categories[indexPath.row].id)
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
        itemWidth = collectionWidth/4 - 15
        itemHeight = collectionHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
