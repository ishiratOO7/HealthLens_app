//
//  MockAuthService.swift
//  HealthLens
//
//  Created by Codex.
//

import Foundation

final class MockAuthService: AuthServicing {
    func login(email: String, password: String) async throws -> AuthSession {
        try await simulateLatency()
        try validateLogin(email: email, password: password)

        if email.lowercased().contains("fail") {
            throw AuthError.invalidCredentials
        }

        return makeSession(email: email, displayName: displayName(from: email, fallback: "HealthLens User"))
    }

    func signup(name: String, email: String, password: String) async throws -> AuthSession {
        try await simulateLatency()
        try validateSignup(name: name, email: email, password: password)

        if email.lowercased().contains("taken") {
            throw AuthError.emailAlreadyInUse
        }

        return makeSession(email: email, displayName: name)
    }

    private func simulateLatency() async throws {
        try await Task.sleep(nanoseconds: 650_000_000)
    }

    private func validateLogin(email: String, password: String) throws {
        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }

        guard password.count >= 8 else {
            throw AuthError.invalidPassword
        }
    }

    private func validateSignup(name: String, email: String, password: String) throws {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthError.invalidName
        }

        try validateLogin(email: email, password: password)
    }

    private func makeSession(email: String, displayName: String) -> AuthSession {
        AuthSession(
            token: UUID().uuidString.replacingOccurrences(of: "-", with: ""),
            userID: UUID().uuidString,
            displayName: displayName,
            email: email
        )
    }

    private func displayName(from email: String, fallback: String) -> String {
        let prefix = email.split(separator: "@").first.map(String.init)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return prefix.isEmpty ? fallback : prefix
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailPattern, options: .regularExpression) != nil
    }
}
