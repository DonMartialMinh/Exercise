//
//  ImageCollectionViewCell.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/14/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var pictureImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setState(_ state: cellState)
    {
        switch state {
        case .selected:
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.systemBlue.cgColor
        default:
            self.layer.borderWidth = 0
        }
    }

}

enum cellState {
    case selected
    case normal
}

extension ImageCollectionViewCell {
    static func loadFromNib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
