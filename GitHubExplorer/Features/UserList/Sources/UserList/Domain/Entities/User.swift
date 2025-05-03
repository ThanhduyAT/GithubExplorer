//
//  File.swift
//  UserList
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation
import SwiftData

public struct User: Identifiable, Sendable {
    public let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    
    public init(id: Int, login: String, avatarUrl: String, htmlUrl: String) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
    }
}
