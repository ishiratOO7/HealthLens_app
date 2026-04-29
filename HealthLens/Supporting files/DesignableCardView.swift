//
//  DesignableCardView.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//


import UIKit

@IBDesignable
final class DesignableCardView: UIView {

    // MARK: - Corner Radius

    @IBInspectable var cornerRadius: CGFloat = 12 {
        didSet {
            updateAppearance()
        }
    }

    // MARK: - Border

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    // MARK: - Shadow

    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.2 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 6 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .white
        layer.masksToBounds = false
        updateAppearance()
    }

    private func updateAppearance() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        updateShadowPath()
    }

    private func updateShadowPath() {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset

        // Important for performance + smooth rendering
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
}