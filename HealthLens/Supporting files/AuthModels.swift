//
//  AuthModels.swift
//  HealthLens
//
//  Created by Codex.
//

import Foundation

struct AuthSession: Equatable {
    let token: String
    let userID: String
    let displayName: String
    let email: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct SignupRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct AuthResponsePayload: Codable {
    struct User: Codable {
        let id: String
        let name: String
        let email: String
    }

    let token: String
    let user: User
}

struct AuthServerErrorPayload: Codable {
    let message: String
}

enum AuthInputValidator {
    static let minimumPasswordLength = 8

    static func validateLogin(email: String, password: String) -> AuthError? {
        guard isValidEmail(email) else {
            return .invalidEmail
        }

        guard password.count >= minimumPasswordLength else {
            return .invalidPassword
        }

        return nil
    }

    static func validateSignup(
        name: String,
        email: String,
        password: String,
        confirmPassword: String? = nil
    ) -> AuthError? {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .invalidName
        }

        if let loginError = validateLogin(email: email, password: password) {
            return loginError
        }

        if let confirmPassword, password != confirmPassword {
            return .passwordsDoNotMatch
        }

        return nil
    }

    static func isValidEmail(_ email: String) -> Bool {
        let emailPattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailPattern, options: .regularExpression) != nil
    }
}

enum AuthError: LocalizedError, Equatable {
    case invalidEmail
    case invalidName
    case invalidPassword
    case passwordsDoNotMatch
    case invalidCredentials
    case emailAlreadyInUse
    case requestFailed
    case invalidResponse
    case server(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Enter a valid email address."
        case .invalidName:
            return "Enter your name."
        case .invalidPassword:
            return "Enter a password with at least 8 characters."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        case .invalidCredentials:
            return "We couldn't sign you in. Check your details and try again."
        case .emailAlreadyInUse:
            return "That email is already in use."
        case .requestFailed:
            return "We couldn't reach the server."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .server(let message):
            return message.isEmpty ? "The server returned an error." : message
        }
    }
}
