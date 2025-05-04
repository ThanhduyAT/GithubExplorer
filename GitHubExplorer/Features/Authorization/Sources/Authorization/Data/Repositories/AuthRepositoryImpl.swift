//
//  File.swift
//  Authorization
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation
import Networking

final class AuthRepositoryImpl {
    private let apiClient: AuthorizationApiClient
    private let authService: AuthenticationService
    private let clientID = "Ov23lizYkFm5LQFq01yf"
    
    public init(apiClient: AuthorizationApiClient, authService: AuthenticationService) {
        self.apiClient = apiClient
        self.authService = authService
    }
}

extension AuthRepositoryImpl: AuthRepository {
    func openGitHubLogin() -> URL? {
        let redirectURI = "githubexplorer://auth"
        let scope = "user"
        let authURL = "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=\(scope)"
        return URL(string: authURL)
    }
    
    func exchangeCodeForAccessToken(code: String) async throws {
        let request = AuthorizationRequest(
            clientId: "Ov23lizYkFm5LQFq01yf",
            clientSecret: "b6ab9cd23af0a26f92095b5d6b76bb30a233dc28",
            code: code
        )
        let result = try await apiClient.getAccessToken(request: request)
        if let accessToken = result.accessToken {
            print("accessToken", accessToken)
            try authService.saveToken(accessToken)
        }
    }
}
