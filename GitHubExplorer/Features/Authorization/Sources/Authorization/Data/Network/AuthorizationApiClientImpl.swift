//
//  File.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation
import Moya
import Networking

/// Implementation of the `AuthorizationApiClient` using Moya for network abstraction.
struct AuthorizationApiClientImpl: AuthorizationApiClient {
    typealias Target = AuthorizationTargetBuilder

    /// Moya provider used to send requests.
    public var moyaProvider: MoyaProvider<Target>

    /// Initializes the API client with customizable Moya configurations.
    init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
        session: Session = DefaultAlamofireManager.sharedManager,
        plugins: [PluginType] = [],
        trackInflights: Bool = false
    ) {
        self.moyaProvider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }

    /// Sends a request to fetch an access token.
    func getAccessToken(request: AuthorizationRequest) async throws -> AuthorizationResponse {
        // NOTE: Base URL is hardcoded here. Consider externalizing for environment flexibility.
        let baseURL = URL(string: "https://github.com")!
        let target = Target(operation: .getAccessToken(request: request), baseURL: baseURL)
        let result = try await moyaProvider.baseRequest(target, type: AuthorizationResponse.self)
        return result
    }
    
    func getGitHubDeviceCode(clientId: String) async throws -> GitHubDeviceCodeResponse {
        let baseURL = URL(string: "https://github.com")!
        let target = Target(operation: .getDeviceCode(clientId: clientId), baseURL: baseURL)
        let result = try await moyaProvider.baseRequest(target, type: GitHubDeviceCodeResponse.self)
        return result
    }
    
    func pollForAccessToken(clientId: String, deviceCode: String) async throws -> GitHubAccessTokenResponse {
        let baseURL = URL(string: "https://github.com")!
        let target = Target(operation: .pollAccessToken(clientId: clientId, deviceCode: deviceCode), baseURL: baseURL)
        let result = try await moyaProvider.baseRequest(target, type: GitHubAccessTokenResponse.self)
        return result
    }
}
