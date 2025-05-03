//
//  File.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation
import Moya

/// Builds Moya targets for authorization-related network requests.
struct AuthorizationTargetBuilder: TargetType, AccessTokenAuthorizable {
    /// The specific API operation to perform.
    let operation: OperationType

    /// The base URL for the request.
    var baseURL: URL

    /// The path component of the URL, based on the operation.
    var path: String {
        switch operation {
        case .getAccessToken, .pollAccessToken:
            return "/login/oauth/access_token"
        case .getDeviceCode:
            return "/login/device/code"
        }
    }

    /// The HTTP method to use for the request.
    var method: Moya.Method {
        switch operation {
        case .getAccessToken, .getDeviceCode, .pollAccessToken:
            return .post
        }
    }

    /// The task to perform, including parameters and encoding.
    var task: Task {
        switch operation {
        case let .pollAccessToken(clientId, deviceCode):
            return .requestParameters(
                parameters: [
                    "client_id": clientId,
                    "device_code": deviceCode,
                    "grant_type": "urn:ietf:params:oauth:grant-type:device_code"
                ],
                encoding: URLEncoding.default
            )
        case .getAccessToken(let request):
            return .requestParameters(
                parameters: [
                    "client_id": request.clientId,
                    "client_secret": request.clientSecret,
                    "code": request.code
                ],
                encoding: URLEncoding.default
            )
        case let .getDeviceCode(clientId):
            return .requestParameters(
                parameters: [
                    "client_id": clientId,
                    "scope": "read:user"
                ],
                encoding: URLEncoding.httpBody
            )
        }
    }

    /// Specifies acceptable HTTP status codes.
    public var validationType: Moya.ValidationType {
        .none
    }

    /// HTTP headers to send with the request.
    public var headers: [String: String]? {
        switch operation {
        case .getAccessToken, .getDeviceCode, .pollAccessToken:
            return ["Accept": "application/json"]
        }
    }

    /// Type of authorization needed for the request.
    public var authorizationType: AuthorizationType? = nil
}

// MARK: - Supported Operations
extension AuthorizationTargetBuilder {
    enum OperationType {
        case getAccessToken(request: AuthorizationRequest)
        case getDeviceCode(clientId: String)
        case pollAccessToken(clientId: String, deviceCode: String)
    }
}
