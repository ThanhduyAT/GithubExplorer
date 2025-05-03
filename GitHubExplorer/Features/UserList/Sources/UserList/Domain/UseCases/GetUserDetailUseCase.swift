//
//  File.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

/// Defines the contract for retrieving user detail by username.
/// `mutating` is required for value type (struct) conformers to avoid compiler errors
/// when `self` is mutated during async operations.
protocol GetUserDetailUseCase {
    mutating func execute(userName: String) async throws -> UserDetail
}

/// Default implementation of `GetUserDetailUseCase` using repository pattern.
class GetUserDetailUseCaseImpl {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension GetUserDetailUseCaseImpl: GetUserDetailUseCase {
    // `mutating` not needed here because this is a class.
    nonisolated func execute(userName: String) async throws -> UserDetail {
        return try await userRepository.getUserDetail(userName: userName)
    }
}
