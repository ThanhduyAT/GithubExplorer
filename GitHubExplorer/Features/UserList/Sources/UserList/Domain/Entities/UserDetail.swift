//
//  File.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

public struct UserDetail: Sendable {
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let location: String
    let followers: Int
    let following: Int
    
    public init(login: String, avatarUrl: String, htmlUrl: String, location: String, followers: Int, following: Int) {
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.location = location
        self.followers = followers
        self.following = following
    }
}
