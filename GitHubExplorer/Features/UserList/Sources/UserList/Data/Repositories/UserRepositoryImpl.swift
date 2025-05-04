//
//  File.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

// MARK: - UserRepositoryImpl

final class UserRepositoryImpl {
    private let apiClient: UserApiClient
    private let localStorage: UserStorage

    // MARK: - Initialization
    public init(apiClient: UserApiClient, localStorage: UserStorage) {
        self.apiClient = apiClient
        self.localStorage = localStorage
    }
}

// MARK: - UserRepository Conformance

extension UserRepositoryImpl: UserRepository {

    // MARK: - Fetch User List
    public func fetchUserList(query: UserListQuery) async throws -> [User] {
        do {
            // Attempt to fetch users from local storage
            let usersStorage = try await localStorage.fetchUsers()

            // If the query asks for users after "100" and there are already 20 users in storage, return them directly
            if query.since == "100", usersStorage.count >= 20 {
                return usersStorage
            }

            // Fetch users from API if not found in local storage or if additional users are needed
            let usersData = try await apiClient.getUsers(request: UserListRequest.toDTO(query: query))
            let users = usersData.compactMap { $0.toDomain() }
            
            // If local storage has fewer than 40 users, save the fetched users to storage
            if usersStorage.count < 40 {
                try await localStorage.saveUsers(users)
            }
            return users
        } catch {
            throw error
        }
    }

    // MARK: - Get User Detail
    public func getUserDetail(userName: String) async throws -> UserDetail {
        do {
            let user = try await apiClient.getUserDetail(userName: userName)
            return user.toDomain()
        } catch {
            throw error
        }
    }
}
