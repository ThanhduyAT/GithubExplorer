//
//  File.swift
//  Authorization
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

protocol LoginUseCase {
    mutating func execute(code: String) async throws
    mutating func openGitHubLogin() -> URL?
//    
//    mutating func startDeviceFlow() async throws -> GitHubAuth
//    mutating func pollForAccessToken(deviceCode: String, interval: Int) async throws
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
    
//    func startDeviceFlow() async throws -> GitHubAuth {
//        let result = try await authRepository.getGitHubDeviceCodeResponse()
//        return result
//    }
//    
//    func pollForAccessToken(deviceCode: String, interval: Int) async throws {
//        try await authRepository.pollForAccessToken(deviceCode: deviceCode, interval: interval)
//    }
}
