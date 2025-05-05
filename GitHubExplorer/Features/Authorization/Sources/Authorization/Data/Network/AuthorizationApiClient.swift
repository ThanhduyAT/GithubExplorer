//
//  AuthorizationApiClient.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation

protocol AuthorizationApiClient {
    func getAccessToken(request: AuthorizationRequest) async throws -> AuthorizationResponse
    func getGitHubDeviceCode(clientId: String) async throws -> GitHubDeviceCodeResponse
    func pollForAccessToken(clientId: String, deviceCode: String) async throws -> GitHubAccessTokenResponse
}
