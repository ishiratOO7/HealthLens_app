//
//  AuthService.swift
//  HealthLens
//
//  Created by Codex.
//

import Foundation

protocol AuthServicing {
    func login(email: String, password: String) async throws -> AuthSession
    func signup(name: String, email: String, password: String) async throws -> AuthSession
}

enum AuthServiceFactory {
    static func makeService() -> AuthServicing {
        let mode = ProcessInfo.processInfo.environment["HEALTHLENS_AUTH_MODE"]?.lowercased()
        if mode == "remote" {
            return RemoteAuthService(configuration: .placeholder)
        }

        return MockAuthService()
    }
}

struct AuthAPIConfiguration {
    let baseURL: URL
    let requestTimeout: TimeInterval

    static let placeholder = AuthAPIConfiguration(
        baseURL: URL(string: "https://api.healthlens.example/v1")!,
        requestTimeout: 30
    )
}

enum AuthEndpoint {
    case login
    case signup

    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .signup:
            return "auth/signup"
        }
    }
}
