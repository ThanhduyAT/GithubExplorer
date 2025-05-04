//
//  File.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation

public struct UserListResponse: Decodable {
    let id: Int?
    let login: String?
    let avatarUrl: String?
    let htmlUrl: String?
    let url: String?
    let followersUrl: String?
    let followingUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case url
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
    }
}

extension UserListResponse {
    func toDomain() -> User {
        return User(
            id: self.id ?? 0,
            login: self.login ?? "",
            avatarUrl: self.avatarUrl ?? "",
            htmlUrl: self.htmlUrl ?? ""
        )
    }
}
