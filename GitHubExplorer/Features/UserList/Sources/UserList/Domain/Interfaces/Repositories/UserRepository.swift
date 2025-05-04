//
//  UserRepository.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

protocol UserRepository {
    func fetchUserList(query: UserListQuery) async throws -> [User]
    func getUserDetail(userName: String) async throws -> UserDetail
}
