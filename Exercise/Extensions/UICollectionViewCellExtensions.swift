//
//  UICollectionViewCellExtensions.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/19/21.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    static func loadNib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
