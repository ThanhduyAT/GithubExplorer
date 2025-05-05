//
//  MockUserRepository.swift
//  UserList
//
//  Created by Duy Thanh on 4/5/25.
//
import UserList
import Foundation

final class MockUserRepository: @unchecked Sendable, UserRepository {
    var fetchUserListCalled = false
    var expectedResult: [User] = []

    var receivedUsername: String?
    var expectedUserDetail: UserDetail?

    func getUsers(query: UserListQuery) async throws -> [User] {
        fetchUserListCalled = true
        return expectedResult
    }
    
    func getUserDetail(userName: String) async throws -> UserDetail {
        receivedUsername = userName
        if let detail = expectedUserDetail {
            return detail
        } else {
            throw NSError(domain: "MockError", code: 0)
        }
    }
}
