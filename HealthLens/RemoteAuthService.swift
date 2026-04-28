//
//  RemoteAuthService.swift
//  HealthLens
//
//  Created by Codex.
//

import Foundation

final class RemoteAuthService: AuthServicing {
    private let configuration: AuthAPIConfiguration
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(configuration: AuthAPIConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    func login(email: String, password: String) async throws -> AuthSession {
        try await send(.login, body: LoginRequest(email: email, password: password))
    }

    func signup(name: String, email: String, password: String) async throws -> AuthSession {
        try await send(.signup, body: SignupRequest(name: name, email: email, password: password))
    }

    private func send<Body: Encodable>(_ endpoint: AuthEndpoint, body: Body) async throws -> AuthSession {
        let url = configuration.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = configuration.requestTimeout
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(body)

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                if let serverError = try? decoder.decode(AuthServerErrorPayload.self, from: data) {
                    throw AuthError.server(message: serverError.message)
                }

                throw AuthError.server(message: "Server returned status code \(httpResponse.statusCode).")
            }

            let payload = try decoder.decode(AuthResponsePayload.self, from: data)
            return AuthSession(
                token: payload.token,
                userID: payload.user.id,
                displayName: payload.user.name,
                email: payload.user.email
            )
        } catch let authError as AuthError {
            throw authError
        } catch {
            throw AuthError.requestFailed
        }
    }
}
