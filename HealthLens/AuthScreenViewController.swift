//
//  AuthScreenViewController.swift
//  HealthLens
//
//  Created by Codex.
//

import UIKit

@MainActor
class AuthScreenViewController: UIViewController, UITextFieldDelegate {
    enum MessageStyle {
        case neutral
        case success
        case error
    }

    private var orderedTextFields: [UITextField] = []

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HealthLensTheme.Colors.background
        view.tintColor = HealthLensTheme.Colors.gold
    }

    func registerTextFields(_ textFields: [UITextField]) {
        orderedTextFields = textFields

        textFields.forEach { textField in
            HealthLensTheme.applyFieldStyle(to: textField)
            textField.font = HealthLensTheme.Fonts.bodyMedium(16)
            textField.delegate = self

            if let placeholder = textField.placeholder, !placeholder.isEmpty {
                textField.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [
                        .foregroundColor: HealthLensTheme.Colors.textSecondary.withAlphaComponent(0.78),
                        .font: HealthLensTheme.Fonts.bodyMedium(16)
                    ]
                )
            }
        }
    }

    func styleMessageLabel(_ label: UILabel) {
        label.font = HealthLensTheme.Fonts.caption(14)
        label.textColor = HealthLensTheme.Colors.textSecondary
        label.isHidden = true
    }

    func stylePrimaryButton(_ button: UIButton, title: String, systemImageName: String? = nil) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = HealthLensTheme.Colors.gold
        configuration.baseForegroundColor = HealthLensTheme.Colors.tealDark
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 18, bottom: 15, trailing: 18)
        configuration.titleTextAttributesTransformer = HealthLensTheme.textAttributesTransformer(
            font: HealthLensTheme.Fonts.button(17),
            color: HealthLensTheme.Colors.tealDark
        )

        if let systemImageName {
            configuration.image = UIImage(systemName: systemImageName)
            configuration.imagePlacement = .trailing
            configuration.imagePadding = 8
        }

        button.configuration = configuration
    }

    func styleSecondaryButton(_ button: UIButton, title: String, systemImageName: String? = nil) {
        var configuration = UIButton.Configuration.bordered()
        configuration.title = title
        configuration.baseBackgroundColor = HealthLensTheme.Colors.peachSoft
        configuration.baseForegroundColor = HealthLensTheme.Colors.tealMuted
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 18, bottom: 14, trailing: 18)
        configuration.background.strokeColor = HealthLensTheme.Colors.border
        configuration.background.strokeWidth = 1
        configuration.titleTextAttributesTransformer = HealthLensTheme.textAttributesTransformer(
            font: HealthLensTheme.Fonts.button(16),
            color: HealthLensTheme.Colors.tealMuted
        )

        if let systemImageName {
            configuration.image = UIImage(systemName: systemImageName)
            configuration.imagePlacement = .leading
            configuration.imagePadding = 8
        }

        button.configuration = configuration
    }

    func setLoading(
        _ loading: Bool,
        controls: [UIControl],
        primaryButton: UIButton,
        secondaryButton: UIButton,
        primaryTitle: String,
        loadingTitle: String,
        primarySystemImageName: String?,
        secondaryTitle: String,
        secondarySystemImageName: String?
    ) {
        controls.forEach { $0.isEnabled = !loading }
        primaryButton.isEnabled = !loading
        secondaryButton.isEnabled = !loading

        stylePrimaryButton(
            primaryButton,
            title: loading ? loadingTitle : primaryTitle,
            systemImageName: loading ? nil : primarySystemImageName
        )

        var primaryConfiguration = primaryButton.configuration
        primaryConfiguration?.showsActivityIndicator = loading
        primaryButton.configuration = primaryConfiguration

        styleSecondaryButton(
            secondaryButton,
            title: secondaryTitle,
            systemImageName: loading ? nil : secondarySystemImageName
        )

        if loading {
            secondaryButton.alpha = 0.55
        } else {
            secondaryButton.alpha = 1.0
        }
    }

    func showMessage(_ text: String?, style: MessageStyle = .error, in label: UILabel) {
        label.text = text
        label.isHidden = text == nil

        switch style {
        case .neutral:
            label.textColor = HealthLensTheme.Colors.textSecondary
        case .success:
            label.textColor = HealthLensTheme.Colors.success
        case .error:
            label.textColor = HealthLensTheme.Colors.error
        }
    }

    func focusFirstField() {
        orderedTextFields.first?.becomeFirstResponder()
    }

    func isValidEmail(_ email: String) -> Bool {
        AuthInputValidator.isValidEmail(email)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let index = orderedTextFields.firstIndex(of: textField) else {
            textField.resignFirstResponder()
            return true
        }

        let nextIndex = index + 1
        if nextIndex < orderedTextFields.count {
            orderedTextFields[nextIndex].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}
