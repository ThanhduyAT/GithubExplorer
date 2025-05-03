//
//  GitHubAccessTokenResponse.swift
//  Authorization
//
//  Created by Duy Thanh on 3/5/25.
//

import Foundation

struct GitHubAccessTokenResponse: Decodable {
    let accessToken: String?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case error
    }
}
