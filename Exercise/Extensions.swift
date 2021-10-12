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
    case photoSelectViewController
    case designViewController
    case confirmViewController
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
        case .photoSelectViewController:
            return PhotoSelectViewController(nibName: "PhotoSelectViewController", bundle: nil)
        case .designViewController:
            return DesignViewController(nibName: "DesignViewController", bundle: nil)
        case .confirmViewController:
            return ConfirmViewController(nibName: "ConfirmViewController", bundle: nil)
        }
    }
}
