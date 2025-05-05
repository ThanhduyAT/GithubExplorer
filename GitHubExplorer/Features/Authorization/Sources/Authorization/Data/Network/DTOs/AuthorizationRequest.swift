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

extension AuthQuery {
    func toDTO() -> AuthorizationRequest {
        AuthorizationRequest(
            clientId: self.clientId,
            clientSecret: self.clientSecret,
            code: self.code
        )
    }
}
