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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureInputs()
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

    @IBAction private func primaryButtonTapped(_ sender: UIButton) {
        createAccount()
    }

    @IBAction private func secondaryButtonTapped(_ sender: UIButton) {
        goBackToLogin()
    }

    private func createAccount() {
        Task { [weak self] in
            guard let self else { return }

            let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let password = passwordField.text ?? ""
            let confirmPassword = confirmPasswordField.text ?? ""

            guard !name.isEmpty else {
                showMessage(AuthError.invalidName.localizedDescription, in: messageLabel)
                return
            }

            guard isValidEmail(email) else {
                showMessage(AuthError.invalidEmail.localizedDescription, in: messageLabel)
                return
            }

            guard password.count >= 8 else {
                showMessage(AuthError.invalidPassword.localizedDescription, in: messageLabel)
                return
            }

            guard password == confirmPassword else {
                showMessage(AuthError.passwordsDoNotMatch.localizedDescription, in: messageLabel)
                return
            }

            setLoading(
                true,
                controls: [nameField, emailField, passwordField, confirmPasswordField],
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
                showMainPlaceholder()
            } catch is CancellationError {
                // Ignore cancellation.
            } catch let error as LocalizedError {
                showMessage(error.errorDescription ?? AuthError.requestFailed.localizedDescription, in: messageLabel)
            } catch {
                showMessage(AuthError.requestFailed.localizedDescription, in: messageLabel)
            }

            setLoading(
                false,
                controls: [nameField, emailField, passwordField, confirmPasswordField],
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

    private func showMainPlaceholder() {
        guard let mainViewController = healthLens_instantiateStoryboardViewController(
            withIdentifier: "MainViewController",
            as: ViewController.self
        ) else {
            assertionFailure("MainViewController scene is missing from Main.storyboard.")
            return
        }

        healthLens_replaceRootViewController(with: mainViewController)
    }
}
