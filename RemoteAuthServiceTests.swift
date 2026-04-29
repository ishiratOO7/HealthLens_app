import Foundation
import XCTest
@testable import HealthLens

final class RemoteAuthServiceTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.reset()
    }

    func testLoginDecodesSuccessfulResponse() async throws {
        let payload = AuthResponsePayload(
            token: "token-123",
            user: .init(id: "user-1", name: "Sam Carter", email: "sam@example.com")
        )
        let (service, requestObserver) = makeService { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            let data = try JSONEncoder().encode(payload)
            return (response, data)
        }

        let session = try await service.login(email: "sam@example.com", password: "password123")

        XCTAssertEqual(session, AuthSession(token: "token-123", userID: "user-1", displayName: "Sam Carter", email: "sam@example.com"))
        let request = try XCTUnwrap(requestObserver())
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.url?.absoluteString, "https://api.healthlens.example/v1/auth/login")
    }

    func testSignupSurfacesServerMessageForNonSuccessStatus() async {
        let errorPayload = AuthServerErrorPayload(message: "Account already exists.")
        let (service, _) = makeService { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 409, httpVersion: nil, headerFields: nil)!
            let data = try JSONEncoder().encode(errorPayload)
            return (response, data)
        }

        do {
            _ = try await service.signup(name: "Sam", email: "sam@example.com", password: "password123")
            XCTFail("Expected server error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .server(message: "Account already exists."))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testLoginFallsBackToStatusCodeMessageWhenServerPayloadCannotBeDecoded() async {
        let (service, _) = makeService { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 503, httpVersion: nil, headerFields: nil)!
            return (response, Data("no-json".utf8))
        }

        do {
            _ = try await service.login(email: "sam@example.com", password: "password123")
            XCTFail("Expected server error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .server(message: "Server returned status code 503."))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testLoginRejectsNonHTTPResponses() async {
        let configuration = AuthAPIConfiguration.placeholder
        let session = URLSession.stubbed { _ in
            (URLResponse(url: configuration.baseURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil), Data())
        }
        let service = RemoteAuthService(configuration: configuration, session: session)

        do {
            _ = try await service.login(email: "sam@example.com", password: "password123")
            XCTFail("Expected invalid response error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .invalidResponse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testLoginMapsTransportFailuresToRequestFailed() async {
        let session = URLSession.stubbed { _ in
            throw URLError(.notConnectedToInternet)
        }
        let service = RemoteAuthService(configuration: .placeholder, session: session)

        do {
            _ = try await service.login(email: "sam@example.com", password: "password123")
            XCTFail("Expected request failed error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .requestFailed)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    private func makeService(
        handler: @escaping URLProtocolStub.Handler
    ) -> (RemoteAuthService, () -> URLRequest?) {
        let session = URLSession.stubbed(handler: handler)
        let service = RemoteAuthService(configuration: .placeholder, session: session)
        return (service, { URLProtocolStub.recordedRequest })
    }
}

private extension URLSession {
    static func stubbed(handler: @escaping URLProtocolStub.Handler) -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        URLProtocolStub.handler = handler
        return URLSession(configuration: configuration)
    }
}

private final class URLProtocolStub: URLProtocol, @unchecked Sendable {
    typealias Handler = @Sendable (URLRequest) throws -> (URLResponse, Data)

    static var handler: Handler?
    static var recordedRequest: URLRequest?
    private static let lock = NSLock()

    static func reset() {
        lock.withLock {
            handler = nil
            recordedRequest = nil
        }
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let handler = Self.lock.withLock { () -> Handler? in
            Self.recordedRequest = request
            return Self.handler
        }

        guard let handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

private extension NSLock {
    func withLock<T>(_ body: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try body()
    }
}
