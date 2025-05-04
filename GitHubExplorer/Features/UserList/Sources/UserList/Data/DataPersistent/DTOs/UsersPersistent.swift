//
//  UserPersistent.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation
import SwiftData

@Model class UserPersistent {
    var id: Int
    var login: String
    var avatarUrl: String
    var htmlUrl: String

    init(user: User) {
        self.id = user.id
        self.login = user.login
        self.avatarUrl = user.avatarUrl
        self.htmlUrl = user.htmlUrl
    }
}

extension UserPersistent {
    func toDomain() -> User {
        return User(
            id: self.id,
            login: self.login,
            avatarUrl: self.avatarUrl,
            htmlUrl: self.htmlUrl
        )
    }
}
