//
//  UIColorExtensions.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/19/21.
//

import UIKit

enum AssetsColor {
    case orange
    case purple
    case lightGreen
    case darkPurple
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .orange:
            return UIColor(named: "orange")
        case .purple:
            return UIColor(named: "purple")
        case .lightGreen:
            return UIColor(named: "lightGreen")
        case .darkPurple:
            return UIColor(named: "darkPurple")
        }
    }
}
