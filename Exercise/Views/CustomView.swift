//
//  CustomView.swift
//  Exercise
//
//  Created by Vo Minh Don on 10/7/21.
//

import UIKit

@IBDesignable class CustomView: UIView {
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UI Setup
    override func prepareForInterfaceBuilder() {
        setupView()
    }

    func setupView() {
        self.backgroundColor = color
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowOffset = shadowOffset
    }

    // MARK: - Properties
    @IBInspectable
    var color: UIColor = .systemBlue {
        didSet {
            self.backgroundColor = color
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    var shadowColor: UIColor = .black {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }

    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable
    var shadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
