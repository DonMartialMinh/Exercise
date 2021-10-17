//
//  extensions.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/11/21.
//

import Foundation
import UIKit

enum AssetsColor {
    case orange
    case purple
    case lightGreen
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
            
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
