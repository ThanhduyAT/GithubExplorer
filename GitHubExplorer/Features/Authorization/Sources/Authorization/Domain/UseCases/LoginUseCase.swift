//
//  LoginUseCase.swift
//  Authorization
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

protocol LoginUseCase {
    mutating func execute(code: String) async throws
    mutating func openGitHubLogin() -> URL?
}

class LoginUseCaseImpl {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension LoginUseCaseImpl: LoginUseCase {
    func openGitHubLogin() -> URL? {
        return authRepository.openGitHubLogin()
    }

    func execute(code: String) async throws {
        try await authRepository.exchangeCodeForAccessToken(code: code)
    }
}
