//
//  UserTargetBuilder.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation
import Moya

// MARK: - UserTargetBuilder

struct UserTargetBuilder: TargetType, AccessTokenAuthorizable {

    let operation: OperationType
    var baseURL: URL

    // MARK: - Path

    // Define the path for each operation
    var path: String {
        switch operation {
        case .fetchUserList:
            return "/users"
        case let .getUserDetail(userName):
            return "/users/\(userName)"
        }
    }

    // MARK: - HTTP Method

    var method: Moya.Method {
        switch operation {
        case .fetchUserList, .getUserDetail:
            return .get
        }
    }

    // MARK: - Task

    var task: Moya.Task {
        switch operation {
        case let .fetchUserList(request):
            return .requestParameters(
                parameters: [
                    "since": request.since,
                    "per_page": request.perPage
                ],
                encoding: URLEncoding.default
            )
        case .getUserDetail:
            return .requestPlain
        }
    }

    // MARK: - Validation

    var validationType: Moya.ValidationType {
        .none
    }

    // MARK: - Headers

    public var headers: [String: String]? {
        [:]
    }

    // MARK: - Authorization

    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}

// MARK: - OperationType Enum

extension UserTargetBuilder {
    enum OperationType {
        case fetchUserList(request: UserListRequest)
        case getUserDetail(userName: String)
    }
}
