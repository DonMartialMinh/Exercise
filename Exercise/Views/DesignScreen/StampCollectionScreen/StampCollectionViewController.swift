//
//  StampCollectionViewController.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/20/21.
//

import UIKit

class StampCollectionViewController: UIViewController {
  private var stamps: [Stamp] = []
  private var categories: [Category] = []
  // MARK: - IBOutlet
  @IBOutlet weak var stampCollectionView: UICollectionView!
  @IBOutlet weak var categotyCollectionView: UICollectionView!
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    stampCollectionView.register(ImageCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
    stampCollectionView.delegate = self
    stampCollectionView.dataSource = self
    stampCollectionView.allowsMultipleSelection = false
    
    categotyCollectionView.register(CategoryCollectionViewCell.loadNib(), forCellWithReuseIdentifier: Constants.categoryCellIdentifier)
    categotyCollectionView.delegate = self
    categotyCollectionView.dataSource = self
    categotyCollectionView.allowsMultipleSelection = false
    fetchCategories()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    guard let flowLayout = stampCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    flowLayout.invalidateLayout()
  }

  // MARK: - ButtonPressed
  @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  // MARK: - fetchData
  func fetchCategories() {
    APIManager.shared.fetchCategories { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let categories):
        self.categories.append(contentsOf: categories!.data)
        DispatchQueue.main.async {
          self.categotyCollectionView.reloadData()
        }
      case .failure(let error):
        print("Request failed with error \(error)")
      }
    }
  }
  func fetchStamps(with id: Int) {
    APIManager.shared.fetchStamps(id: id) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let stamps):
        self.stamps.removeAll()
        self.stamps.append(contentsOf: stamps!.data)
        DispatchQueue.main.async {
          self.stampCollectionView.reloadData()
        }
      case .failure(let error):
        print("Request failed with error \(error)")
      }
    }
  }
}

// MARK: - UICollectionViewDatasource
extension StampCollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == stampCollectionView {
      return stamps.count
    } else {
      return categories.count
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == stampCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCellIdentifier, for: indexPath) as! ImageCollectionViewCell
      let imageUrl = stamps[indexPath.row].thumbnailImageUrl
      cell.pictureImageView.loadFromUrl(imageUrl)
      cell.pictureImageView.contentMode = .scaleAspectFit
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.categoryCellIdentifier, for: indexPath) as! CategoryCollectionViewCell
      cell.titleLabel.text = categories[indexPath.row].name
      return cell
    }
  }
}

// MARK: - UICollectionViewDelegate
extension StampCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == categotyCollectionView {
      let selectedCell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
      selectedCell.setState(.selected)
      fetchStamps(with: categories[indexPath.row].id)
    }
  }
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if collectionView == categotyCollectionView {
      let selectedCell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
      selectedCell.setState(.normal)
    }
  }
}

// MARK: - UICollectionViewFlowLayout
extension StampCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionWidth = Double(collectionView.bounds.width)
    let collectionHeight = Double(collectionView.bounds.height)
    var itemWidth: Double
    var itemHeight: Double
    if collectionView == stampCollectionView {
      if UIDevice.current.orientation.isLandscape {
        itemWidth = collectionWidth/5 - 15
      } else {
        itemWidth = collectionWidth/3 - 15
      }
      itemHeight = itemWidth
    } else {
      itemHeight = collectionHeight
      itemWidth = collectionWidth/4 - 15
    }
    return CGSize(width: itemWidth, height: itemHeight)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
}
