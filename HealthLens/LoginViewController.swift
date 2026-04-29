//
//  LoginViewController.swift
//  HealthLens
//
//  Created by Codex.
//

import UIKit

final class LoginViewController: AuthScreenViewController {
    private enum Copy {
        static let primaryTitle = "Sign In"
        static let primaryLoadingTitle = "Signing In"
        static let primarySystemImage = "arrow.right.circle.fill"
        static let temporaryAccessTitle = "Use Temporary Access"
        static let temporaryAccessSystemImage = "person.crop.circle.badge.checkmark"
        static let secondaryTitle = "Create Account"
        static let secondarySystemImage = "person.badge.plus"
    }

    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var primaryButton: UIButton!
    @IBOutlet private weak var secondaryButton: UIButton!
    @IBOutlet private weak var formCardView: UIView!

    private let authService = AuthServiceFactory.makeService()
    private lazy var temporaryAccessButton = makeSecondaryActionButton(
        title: Copy.temporaryAccessTitle,
        systemImageName: Copy.temporaryAccessSystemImage,
        target: self,
        action: #selector(temporaryAccessButtonTapped)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureInputs()
        configureTemporaryAccess()
    }

    private func configureAppearance() {
        HealthLensTheme.applyCardStyle(to: formCardView, backgroundColor: HealthLensTheme.Colors.surface)
        styleMessageLabel(messageLabel)
        stylePrimaryButton(primaryButton, title: Copy.primaryTitle, systemImageName: Copy.primarySystemImage)
        styleSecondaryButton(secondaryButton, title: Copy.secondaryTitle, systemImageName: Copy.secondarySystemImage)
    }

    private func configureInputs() {
        emailField.keyboardType = .emailAddress
        emailField.textContentType = .emailAddress
        emailField.returnKeyType = .next
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.clearButtonMode = .whileEditing

        passwordField.textContentType = .password
        passwordField.returnKeyType = .done
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.clearButtonMode = .whileEditing

        registerTextFields([emailField, passwordField])
    }

    private func configureTemporaryAccess() {
        guard let formStackView = firstFormStackView(in: formCardView) else {
            assertionFailure("Login form stack view is missing.")
            return
        }

        formStackView.insertArrangedSubview(temporaryAccessButton, at: 4)
    }

    @IBAction private func primaryButtonTapped(_ sender: UIButton) {
        signIn()
    }

    @IBAction private func secondaryButtonTapped(_ sender: UIButton) {
        showSignupScreen()
    }

    @objc private func temporaryAccessButtonTapped() {
        healthLens_showMainDashboard()
    }

    private func signIn() {
        Task { [weak self] in
            guard let self else { return }

            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let password = passwordField.text ?? ""

            if let validationError = AuthInputValidator.validateLogin(email: email, password: password) {
                showMessage(validationError.localizedDescription, in: messageLabel)
                return
            }

            setLoading(
                true,
                controls: [emailField, passwordField, temporaryAccessButton],
                primaryButton: primaryButton,
                secondaryButton: secondaryButton,
                primaryTitle: Copy.primaryTitle,
                loadingTitle: Copy.primaryLoadingTitle,
                primarySystemImageName: Copy.primarySystemImage,
                secondaryTitle: Copy.secondaryTitle,
                secondarySystemImageName: Copy.secondarySystemImage
            )
            showMessage(nil, style: .neutral, in: messageLabel)

            do {
                _ = try await authService.login(email: email, password: password)
                healthLens_showMainDashboard()
            } catch is CancellationError {
                // Ignore cancellation.
            } catch let error as LocalizedError {
                showMessage(error.errorDescription ?? AuthError.requestFailed.localizedDescription, in: messageLabel)
            } catch {
                showMessage(AuthError.requestFailed.localizedDescription, in: messageLabel)
            }

            setLoading(
                false,
                controls: [emailField, passwordField, temporaryAccessButton],
                primaryButton: primaryButton,
                secondaryButton: secondaryButton,
                primaryTitle: Copy.primaryTitle,
                loadingTitle: Copy.primaryLoadingTitle,
                primarySystemImageName: Copy.primarySystemImage,
                secondaryTitle: Copy.secondaryTitle,
                secondarySystemImageName: Copy.secondarySystemImage
            )
        }
    }

    private func showSignupScreen() {
        guard let signupViewController = healthLens_instantiateStoryboardViewController(
            withIdentifier: "SignupViewController",
            as: SignupViewController.self
        ) else {
            assertionFailure("SignupViewController scene is missing from Main.storyboard.")
            return
        }

        healthLens_presentFullScreen(signupViewController)
    }
}
