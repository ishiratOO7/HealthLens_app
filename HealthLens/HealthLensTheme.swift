//
//  HealthLensTheme.swift
//  HealthLens
//
//  Created by Codex.
//

import UIKit

enum HealthLensTheme {
    enum Colors {
        static let background = UIColor(red: 0.93, green: 0.95, blue: 0.92, alpha: 1.0)
        static let surface = UIColor(red: 0.99, green: 0.98, blue: 0.96, alpha: 1.0)
        static let surfaceSoft = UIColor(red: 0.98, green: 0.96, blue: 0.92, alpha: 1.0)
        static let teal = UIColor(red: 0.11, green: 0.31, blue: 0.35, alpha: 1.0)
        static let tealDark = UIColor(red: 0.08, green: 0.24, blue: 0.28, alpha: 1.0)
        static let tealMuted = UIColor(red: 0.19, green: 0.45, blue: 0.49, alpha: 1.0)
        static let gold = UIColor(red: 0.96, green: 0.71, blue: 0.35, alpha: 1.0)
        static let goldSoft = UIColor(red: 0.98, green: 0.83, blue: 0.58, alpha: 1.0)
        static let peach = UIColor(red: 0.97, green: 0.88, blue: 0.80, alpha: 1.0)
        static let peachSoft = UIColor(red: 0.99, green: 0.95, blue: 0.91, alpha: 1.0)
        static let textPrimary = UIColor(red: 0.14, green: 0.22, blue: 0.24, alpha: 1.0)
        static let textSecondary = UIColor(red: 0.45, green: 0.50, blue: 0.51, alpha: 1.0)
        static let border = UIColor(red: 0.86, green: 0.82, blue: 0.75, alpha: 1.0)
        static let shadow = UIColor(red: 0.05, green: 0.18, blue: 0.22, alpha: 0.20)
        static let success = UIColor(red: 0.19, green: 0.58, blue: 0.45, alpha: 1.0)
        static let error = UIColor(red: 0.80, green: 0.36, blue: 0.30, alpha: 1.0)
    }

    enum Fonts {
        private enum File {
            static let regularCandidates = ["Poppins-Regular", "Poppins Regular", "Poppins"]
            static let mediumCandidates = ["Poppins-Medium", "Poppins Medium"]
            static let semiBoldCandidates = ["Poppins-SemiBold", "Poppins SemiBold"]
            static let boldCandidates = ["Poppins-Bold", "Poppins Bold"]
        }

        static func brand(_ size: CGFloat) -> UIFont {
            scaledFont(
                candidates: File.semiBoldCandidates,
                size: size,
                fallbackWeight: .semibold,
                textStyle: .caption1
            )
        }

        static func title(_ size: CGFloat) -> UIFont {
            scaledFont(
                candidates: File.semiBoldCandidates,
                size: size,
                fallbackWeight: .semibold,
                textStyle: .title1
            )
        }

        static func subtitle(_ size: CGFloat) -> UIFont {
            scaledFont(
                candidates: File.regularCandidates,
                size: size,
                fallbackWeight: .regular,
                textStyle: .body
            )
        }

        static func body(_ size: CGFloat) -> UIFont {
            scaledFont(
                candidates: File.regularCandidates,
                size: size,
                fallbackWeight: .regular,
                textStyle: .body
            )
        }

        static func bodyMedium(_ size: CGFloat) -> UIFont {
            scaledFont(
                candidates: File.mediumCandidates,
                size: size,
                fallbackWeight: .medium,
                textStyle: .body
            )
        }

        static func button(_ size: CGFloat) -> UIFont {
            scaledFont(
                candidates: File.mediumCandidates,
                size: size,
                fallbackWeight: .medium,
                textStyle: .headline
            )
        }

        static func caption(_ size: CGFloat) -> UIFont {
            scaledFont(
                candidates: File.regularCandidates,
                size: size,
                fallbackWeight: .regular,
                textStyle: .caption1
            )
        }

        static func headline(_ size: CGFloat) -> UIFont {
            scaledFont(
                candidates: File.boldCandidates,
                size: size,
                fallbackWeight: .bold,
                textStyle: .headline
            )
        }

        private static func scaledFont(
            candidates: [String],
            size: CGFloat,
            fallbackWeight: UIFont.Weight,
            textStyle: UIFont.TextStyle
        ) -> UIFont {
            let baseFont = candidates.lazy.compactMap { UIFont(name: $0, size: size) }.first
                ?? fallbackFont(weight: fallbackWeight, size: size)

            return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
        }

        private static func fallbackFont(weight: UIFont.Weight, size: CGFloat) -> UIFont {
            let preferredFont = UIFont.systemFont(ofSize: size, weight: weight)
            if let roundedDescriptor = preferredFont.fontDescriptor.withDesign(.rounded) {
                return UIFont(descriptor: roundedDescriptor, size: size)
            }
            return preferredFont
        }
    }

    enum Metrics {
        static let cardCornerRadius: CGFloat = 30
        static let fieldCornerRadius: CGFloat = 18
        static let buttonCornerRadius: CGFloat = 22
        static let cardShadowRadius: CGFloat = 28
        static let cardShadowOpacity: Float = 0.16
        static let cardShadowOffset = CGSize(width: 0, height: 18)
    }

    static func applyCardStyle(
        to view: UIView,
        backgroundColor: UIColor = Colors.surface,
        borderColor: UIColor = Colors.border,
        cornerRadius: CGFloat = Metrics.cardCornerRadius
    ) {
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = borderColor.cgColor
        view.layer.shadowColor = Colors.shadow.cgColor
        view.layer.shadowOpacity = Metrics.cardShadowOpacity
        view.layer.shadowRadius = Metrics.cardShadowRadius
        view.layer.shadowOffset = Metrics.cardShadowOffset
        view.layer.masksToBounds = false
    }

    static func applyHeroCardStyle(to view: UIView) {
        view.backgroundColor = Colors.tealDark
        view.layer.cornerRadius = Metrics.cardCornerRadius
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = Colors.shadow.cgColor
        view.layer.shadowOpacity = 0.22
        view.layer.shadowRadius = Metrics.cardShadowRadius
        view.layer.shadowOffset = Metrics.cardShadowOffset
        view.layer.masksToBounds = false
    }

    static func applyFieldStyle(to field: UITextField) {
        field.backgroundColor = Colors.surfaceSoft
        field.textColor = Colors.textPrimary
        field.tintColor = Colors.gold
        field.layer.cornerRadius = Metrics.fieldCornerRadius
        field.layer.cornerCurve = .continuous
        field.layer.borderWidth = 1
        field.layer.borderColor = Colors.border.cgColor
        field.layer.masksToBounds = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 1))
        field.leftViewMode = .always
    }

    static func textAttributesTransformer(font: UIFont, color: UIColor? = nil) -> UIConfigurationTextAttributesTransformer {
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            if let color {
                outgoing.foregroundColor = color
            }
            return outgoing
        }
    }
}
