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

enum AppViewController {
    case FirstViewController
    case SecondViewController
    case ThirdViewController
    case FourViewController
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .orange:
            return UIColor(named: "orange")
        }
    }
}

extension UIViewController {
    static func appViewController(_ name: AppViewController) -> UIViewController {
        switch name {
        case .FirstViewController:
            return FirstViewController(nibName: "FirstViewController", bundle: nil)
        case .SecondViewController:
            return SecondViewController(nibName: "SecondViewController", bundle: nil)
        case .ThirdViewController:
            return ThirdViewController(nibName: "ThirdViewController", bundle: nil)
        case .FourViewController:
            return FourViewController(nibName: "FourViewController", bundle: nil)
        }
    }
}
