import XCTest
@testable import HealthLens

final class AuthInputValidatorTests: XCTestCase {
    func testValidateLoginRejectsInvalidEmail() {
        let error = AuthInputValidator.validateLogin(email: "not-an-email", password: "password123")

        XCTAssertEqual(error, .invalidEmail)
    }

    func testValidateLoginRejectsShortPassword() {
        let error = AuthInputValidator.validateLogin(email: "user@example.com", password: "short")

        XCTAssertEqual(error, .invalidPassword)
    }

    func testValidateSignupRejectsEmptyName() {
        let error = AuthInputValidator.validateSignup(
            name: "   ",
            email: "user@example.com",
            password: "password123",
            confirmPassword: "password123"
        )

        XCTAssertEqual(error, .invalidName)
    }

    func testValidateSignupRejectsMismatchedPasswords() {
        let error = AuthInputValidator.validateSignup(
            name: "Jordan",
            email: "user@example.com",
            password: "password123",
            confirmPassword: "password124"
        )

        XCTAssertEqual(error, .passwordsDoNotMatch)
    }
}
