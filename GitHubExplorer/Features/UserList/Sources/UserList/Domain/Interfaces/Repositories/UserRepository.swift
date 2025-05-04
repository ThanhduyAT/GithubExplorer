//
//  UserRepository.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

public protocol UserRepository {
    func getUsers(query: UserListQuery) async throws -> [User]
    func getUserDetail(userName: String) async throws -> UserDetail
}
