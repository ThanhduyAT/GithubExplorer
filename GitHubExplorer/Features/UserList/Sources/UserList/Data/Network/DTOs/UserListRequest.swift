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

extension UserListQuery {
    func toDTO() -> UserListRequest {
        UserListRequest(
            since: self.since,
            perPage: self.perPage
        )
    }
}
