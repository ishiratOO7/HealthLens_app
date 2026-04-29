//
//  MockAuthService.swift
//  HealthLens
//
//  Created by Codex.
//

import Foundation

final class MockAuthService: AuthServicing {
    private let latencyNanoseconds: UInt64
    private let sleep: @Sendable (UInt64) async throws -> Void

    init(
        latencyNanoseconds: UInt64 = 650_000_000,
        sleep: @escaping @Sendable (UInt64) async throws -> Void = { duration in
            try await Task.sleep(nanoseconds: duration)
        }
    ) {
        self.latencyNanoseconds = latencyNanoseconds
        self.sleep = sleep
    }

    func login(email: String, password: String) async throws -> AuthSession {
        try await simulateLatency()
        if let validationError = AuthInputValidator.validateLogin(email: email, password: password) {
            throw validationError
        }

        if email.lowercased().contains("fail") {
            throw AuthError.invalidCredentials
        }

        return makeSession(email: email, displayName: displayName(from: email, fallback: "HealthLens User"))
    }

    func signup(name: String, email: String, password: String) async throws -> AuthSession {
        try await simulateLatency()
        if let validationError = AuthInputValidator.validateSignup(name: name, email: email, password: password) {
            throw validationError
        }

        if email.lowercased().contains("taken") {
            throw AuthError.emailAlreadyInUse
        }

        return makeSession(email: email, displayName: name)
    }

    private func simulateLatency() async throws {
        guard latencyNanoseconds > 0 else {
            return
        }

        try await sleep(latencyNanoseconds)
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
}
