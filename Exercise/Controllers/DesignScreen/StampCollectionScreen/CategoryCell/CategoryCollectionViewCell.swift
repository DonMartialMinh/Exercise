//
//  CategoryCollectionViewCell.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/25/21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var triangleImageView: UIImageView!

    // MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 5.0
    }

    func setState(_ state: CellState) {
        switch state {
        case .selected:
            titleLabel.textColor = UIColor.white
            backView.backgroundColor = UIColor.appColor(.darkPurple)
            triangleImageView.isHidden = false
        case .normal:
            titleLabel.textColor = UIColor.black
            backView.backgroundColor = UIColor.white
            triangleImageView.isHidden = true
        }
    }
}
