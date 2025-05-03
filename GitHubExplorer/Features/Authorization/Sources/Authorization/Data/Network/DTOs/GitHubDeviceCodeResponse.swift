//
//  GitHubDeviceCodeResponse.swift
//  Authorization
//
//  Created by Duy Thanh on 3/5/25.
//

import Foundation

struct GitHubDeviceCodeResponse: Decodable {
    let deviceCode: String?
    let userCode: String?
    let verificationURI: String?
    let expiresIn: Int?
    let interval: Int?

    enum CodingKeys: String, CodingKey {
        case deviceCode = "device_code"
        case userCode = "user_code"
        case verificationURI = "verification_uri"
        case expiresIn = "expires_in"
        case interval
    }
}

extension GitHubDeviceCodeResponse {
    func toDomain() -> GitHubAuth {
        return GitHubAuth(
            deviceCode: deviceCode ?? "",
            userCode: userCode ?? "",
            verificationUri: verificationURI ?? "",
            expiresIn: expiresIn ?? 0,
            interval: interval ?? 0
        )
    }
}
