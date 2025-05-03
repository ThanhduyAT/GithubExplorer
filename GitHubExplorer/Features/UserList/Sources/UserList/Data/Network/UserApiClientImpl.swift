//
//  File.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation
import Moya
import Networking

struct UserApiClientImpl: UserApiClient {
    
    typealias Target = UserTargetBuilder

    // Moya provider for making network requests
    var moyaProvider: MoyaProvider<Target>

    // DUYFIXME
    private let baseURL: URL = URL(string: "https://api.github.com")!

    // MARK: - Initializer

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

    // MARK: - API Methods

    /// Fetch a list of users based on the provided request parameters
    func fetchUserList(request: UserListRequest) async throws -> [UserListResponse] {
        let target = Target(operation: .fetchUserList(request: request), baseURL: baseURL)
        return try await moyaProvider.baseRequest(target, type: [UserListResponse].self)
    }

    /// Get detailed user information by username
    func getUserDetail(userName: String) async throws -> UserDetailResponse {
        let target = Target(operation: .getUserDetail(userName: userName), baseURL: baseURL)
        return try await moyaProvider.baseRequest(target, type: UserDetailResponse.self)
    }
}
