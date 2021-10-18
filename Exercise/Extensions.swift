//
//  extensions.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/11/21.
//

import Foundation
import UIKit

//MARK: - Color
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

//MARK: - String
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

//MARK: - InterfaceInitable
protocol InterfaceInitable: class {
    static var classId: String { get }
    static func initFromNib() -> Self
}

extension InterfaceInitable where Self: UIViewController {
    static var classId: String {
        autoreleasepool {
            return String(describing: Self.self)
        }
    }
    
    static func initFromNib() -> Self {
        return Self(nibName: classId, bundle: nil)
    }
}
