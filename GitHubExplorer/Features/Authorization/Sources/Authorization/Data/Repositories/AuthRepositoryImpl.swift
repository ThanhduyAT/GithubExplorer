//
//  AuthRepositoryImpl.swift
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
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"
        components.path = "/login/oauth/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: "githubexplorer://auth"),
            URLQueryItem(name: "scope", value: "user")
        ]
        return components.url
    }

    func exchangeCodeForAccessToken(code: String) async throws {
        let request = AuthorizationRequest(
            clientId: "Ov23lizYkFm5LQFq01yf",
            clientSecret: "b6ab9cd23af0a26f92095b5d6b76bb30a233dc28",
            code: code
        )
        let result = try await apiClient.getAccessToken(request: request)
        if let accessToken = result.accessToken {
            try authService.saveToken(accessToken)
        }
    }
}
