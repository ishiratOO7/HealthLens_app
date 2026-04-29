//
//  SignupViewController.swift
//  HealthLens
//
//  Created by Codex.
//

import UIKit

final class SignupViewController: AuthScreenViewController {
    private enum Copy {
        static let primaryTitle = "Create Account"
        static let primaryLoadingTitle = "Creating Account"
        static let primarySystemImage = "checkmark.circle.fill"
        static let temporaryAccessTitle = "Use Temporary Access"
        static let temporaryAccessSystemImage = "person.crop.circle.badge.checkmark"
        static let secondaryTitle = "Back to Login"
        static let secondarySystemImage = "chevron.left"
    }

    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var confirmPasswordField: UITextField!
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
        nameField.textContentType = .name
        nameField.returnKeyType = .next
        nameField.autocapitalizationType = .words
        nameField.autocorrectionType = .no
        nameField.clearButtonMode = .whileEditing

        emailField.keyboardType = .emailAddress
        emailField.textContentType = .emailAddress
        emailField.returnKeyType = .next
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.clearButtonMode = .whileEditing

        passwordField.textContentType = .newPassword
        passwordField.returnKeyType = .next
        passwordField.isSecureTextEntry = true
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.clearButtonMode = .whileEditing

        confirmPasswordField.textContentType = .newPassword
        confirmPasswordField.returnKeyType = .done
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.autocapitalizationType = .none
        confirmPasswordField.autocorrectionType = .no
        confirmPasswordField.clearButtonMode = .whileEditing

        registerTextFields([nameField, emailField, passwordField, confirmPasswordField])
    }

    private func configureTemporaryAccess() {
        guard let formStackView = firstFormStackView(in: formCardView) else {
            assertionFailure("Signup form stack view is missing.")
            return
        }

        formStackView.insertArrangedSubview(temporaryAccessButton, at: 6)
    }

    @IBAction private func primaryButtonTapped(_ sender: UIButton) {
        createAccount()
    }

    @IBAction private func secondaryButtonTapped(_ sender: UIButton) {
        goBackToLogin()
    }

    @objc private func temporaryAccessButtonTapped() {
        healthLens_showMainDashboard()
    }

    private func createAccount() {
        Task { [weak self] in
            guard let self else { return }

            let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let password = passwordField.text ?? ""
            let confirmPassword = confirmPasswordField.text ?? ""

            if let validationError = AuthInputValidator.validateSignup(
                name: name,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            ) {
                showMessage(validationError.localizedDescription, in: messageLabel)
                return
            }

            setLoading(
                true,
                controls: [nameField, emailField, passwordField, confirmPasswordField, temporaryAccessButton],
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
                _ = try await authService.signup(name: name, email: email, password: password)
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
                controls: [nameField, emailField, passwordField, confirmPasswordField, temporaryAccessButton],
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

    private func goBackToLogin() {
        if presentingViewController != nil {
            dismiss(animated: true)
            return
        }

        guard let loginViewController = healthLens_instantiateStoryboardViewController(
            withIdentifier: "LoginViewController",
            as: LoginViewController.self
        ) else {
            assertionFailure("LoginViewController scene is missing from Main.storyboard.")
            return
        }

        healthLens_replaceRootViewController(with: loginViewController)
    }
}
