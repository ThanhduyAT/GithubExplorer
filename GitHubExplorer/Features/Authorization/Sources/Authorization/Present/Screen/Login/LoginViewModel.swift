//
//  File.swift
//  Authorization
//
//  Created by Duy Thanh on 2/5/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable class LoginViewModel {
    // MARK: - Dependencies
    @ObservationIgnored private var loginUseCase: LoginUseCase
    @ObservationIgnored private let onLoginSuccess: () -> Void

    // MARK: - State
    var error: Error?

    // MARK: - Init
    init(factory: LoginFactory, onLoginSuccess: @escaping () -> Void) {
        self.loginUseCase = factory.makeLoginUseCase()
        self.onLoginSuccess = onLoginSuccess
    }

    // MARK: - Public Methods
    func openGitHubLogin() -> URL? {
        loginUseCase.openGitHubLogin()
    }

    func performLogin(code: String) async {
        do {
            try await loginUseCase.execute(code: code)
            onLoginSuccess()
        } catch {
            self.error = error
        }
    }
}
