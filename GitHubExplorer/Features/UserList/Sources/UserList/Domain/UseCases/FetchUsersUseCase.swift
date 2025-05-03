//
//  File.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

/// Defines the contract for fetching users with a query.
/// The `mutating` keyword is required to support value type (struct) conformers,
/// since calling an `async` method that potentially modifies `self` would trigger a data race without it.
protocol FetchUsersUseCase {
    mutating func execute(query: UserListQuery) async throws -> [User]
}

/// Default implementation of `FetchUsersUseCase` using repository pattern.
public class FetchUsersUseCaseImpl {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension FetchUsersUseCaseImpl: FetchUsersUseCase {
    // No need to mark as `mutating` here since this is a class.
    public func execute(query: UserListQuery) async throws -> [User] {
        return try await userRepository.fetchUserList(query: query)
    }
}

