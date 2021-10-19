//
//  UIViewControllerExtensions.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/19/21.
//

import Foundation
import UIKit

extension UIViewController {
    static var classId: String {
        autoreleasepool {
            return String(describing: Self.self)
        }
    }
    
    static func initFromNib() -> Self {
        return Self(nibName: classId, bundle: nil)
    }
}
