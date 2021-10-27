//
//  ImageCollectionViewCell.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/14/21.
//

import UIKit

enum cellState {
    case selected
    case normal
}

class ImageCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var pictureImageView: UIImageView!

    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - SetState
    func setState(_ state: cellState) {
        switch state {
        case .selected:
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.systemBlue.cgColor
        default:
            self.layer.borderWidth = 0
        }
    }
}
