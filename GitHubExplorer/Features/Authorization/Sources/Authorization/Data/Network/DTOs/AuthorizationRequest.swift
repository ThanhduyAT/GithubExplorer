//
//  AuthorizationRequest.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation

public struct AuthorizationRequest {
    let clientId: String
    let clientSecret: String
    let code: String
}

extension AuthorizationRequest {
    static func toDTO(query: AuthQuery) -> AuthorizationRequest {
        AuthorizationRequest(
            clientId: query.clientId,
            clientSecret: query.clientSecret,
            code: query.code
        )
    }
}
