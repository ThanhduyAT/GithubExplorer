//
//  UserListQuery.swift
//  Networking
//
//  Created by Duy Thanh on 30/4/25.
//

import Foundation

public struct UserListQuery: Sendable, Equatable {
    let since: String
    let perPage: String
}
