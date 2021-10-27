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

    // MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
    }

    func setState(_ state: cellState) {
        switch state {
        case .selected:
            titleLabel.textColor = UIColor.white
            self.backgroundColor = UIColor.appColor(.darkPurple)
        case .normal:
            titleLabel.textColor = UIColor.black
            self.backgroundColor = UIColor.white
        }
    }
}
