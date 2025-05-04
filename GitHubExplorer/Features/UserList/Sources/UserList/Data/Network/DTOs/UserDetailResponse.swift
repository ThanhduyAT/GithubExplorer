//
//  UserDetailResponse.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation

public struct UserDetailResponse: Decodable {
    let login: String?
    let avatarUrl: String?
    let htmlUrl: String?
    let location: String?
    let followers: Int?
    let following: Int?
    let reposUrl: String?
    let eventsUrl: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case location
        case followers
        case following
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
    }
}

extension UserDetailResponse {
    func toDomain() -> UserDetail {
        return UserDetail(
            login: self.login ?? "",
            avatarUrl: self.avatarUrl ?? "",
            htmlUrl: self.htmlUrl ?? "",
            location: self.location ?? "",
            followers: self.followers ?? 0,
            following: self.following ?? 0
        )
    }
}
