//
//  UserStorage.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

public protocol UserStorage {
    func saveUsers(_ users: [User]) async throws
    func fetchUsers() async throws -> [User]
}
