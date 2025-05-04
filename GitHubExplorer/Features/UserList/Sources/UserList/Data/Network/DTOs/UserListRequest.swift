//
//  UserListRequest.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation

public struct UserListRequest {
    let since: String
    let perPage: String
}

extension UserListRequest {
    static func toDTO(query: UserListQuery) -> UserListRequest {
        UserListRequest(
            since: query.since,
            perPage: query.perPage
        )
    }
}
