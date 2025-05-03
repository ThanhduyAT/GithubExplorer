//
//  File.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation

struct AuthorizationResponse: Decodable {
    let accessToken: String?
    let scope: String?
    let tokenType: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}

extension AuthorizationResponse {
    func toDomain() -> AuthToken {
        return AuthToken(
            accessToken: accessToken ?? "",
            scope: scope ?? "",
            tokenType: tokenType ?? ""
        )
    }
}
