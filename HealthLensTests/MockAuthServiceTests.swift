import XCTest
@testable import HealthLens

final class MockAuthServiceTests: XCTestCase {
    func testLoginReturnsSessionWithoutWaitingWhenLatencyIsZero() async throws {
        let service = MockAuthService(latencyNanoseconds: 0)

        let session = try await service.login(email: "camila@example.com", password: "password123")

        XCTAssertEqual(session.email, "camila@example.com")
        XCTAssertEqual(session.displayName, "camila")
        XCTAssertFalse(session.token.isEmpty)
        XCTAssertFalse(session.userID.isEmpty)
    }

    func testLoginRejectsFailureAccounts() async {
        let service = MockAuthService(latencyNanoseconds: 0)

        do {
            _ = try await service.login(email: "fail@example.com", password: "password123")
            XCTFail("Expected invalid credentials error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .invalidCredentials)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testSignupRejectsTakenEmail() async {
        let service = MockAuthService(latencyNanoseconds: 0)

        do {
            _ = try await service.signup(name: "Taylor", email: "taken@example.com", password: "password123")
            XCTFail("Expected email already in use error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .emailAlreadyInUse)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
