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
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .orange:
            return UIColor(named: "orange")
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
