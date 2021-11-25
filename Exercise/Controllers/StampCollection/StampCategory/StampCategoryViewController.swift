//
//  CategoryViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/26/21.
//

import UIKit

protocol StampCategoryViewControllerDelegate: class {
    func fetchStamp(_ stampCategoryViewController: StampCategoryViewController, _ id: Int)
}

class StampCategoryViewController: UIViewController {
    private var categories: [StampCategory] = [
        StampCategory(id: 1, name: Constants.savedCategoryTitle.localized)
    ]
    private var selectedCategory: IndexPath? = nil
    private var viewModel = StampCategoryViewModel()
    weak var delegate: StampCategoryViewControllerDelegate?

    // MARK: - IBOutlet
    @IBOutlet weak var stampCategoryCollectionView: UICollectionView!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stampCategoryCollectionView.register(StampCategoryCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.stampCategoryCellIdentifier)
        stampCategoryCollectionView.delegate = self
        stampCategoryCollectionView.dataSource = self
        stampCategoryCollectionView.allowsMultipleSelection = false
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCategories()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedCategory = IndexPath(row: 0, section: 0)
        stampCategoryCollectionView.selectItem(at: selectedCategory, animated: false, scrollPosition: .top)
        delegate?.fetchStamp(self, categories[selectedCategory!.row].id)
        stampCategoryCollectionView.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = stampCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDatasource
extension StampCategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.stampCategoryCellIdentifier, for: indexPath) as! StampCategoryCollectionViewCell
        cell.titleLabel.text = categories[indexPath.row].name
        indexPath == selectedCategory ? cell.setState(.selected) : cell.setState(.normal)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension StampCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! StampCategoryCollectionViewCell
        selectedCell.setState(.selected)
        selectedCategory = indexPath
        delegate?.fetchStamp(self, categories[indexPath.row].id)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? StampCategoryCollectionViewCell else { return }
        selectedCell.setState(.normal)
    }
}

// MARK: - UICollectionViewFlowLayout
extension StampCategoryViewController: UICollectionViewDelegateFlowLayout {
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
extension StampCategoryViewController: StampCategoryViewModelEvents {
    func didUpdateCategory(_ stampCategoryViewModel: StampCategoryViewModel, _ categories: [StampCategory]) {
        self.categories.append(contentsOf: categories)
        DispatchQueue.main.async {
            self.stampCategoryCollectionView.reloadData()
        }
    }

    func didFailWithError(error: ​ResponseError​) {
        let ac = UIAlertController(title: "Error", message: error.errors, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
        print("Request failed with error: \(error)")
    }
}
