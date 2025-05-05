//
//  Container+Domain.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//
import Foundation
import Factory

extension Container {
    /// Provides the use case for fetching a list of users
    var usersUseCase: Factory<FetchUsersUseCase> {
        self {
            FetchUsersUseCaseImpl(userRepository: self.userRepository())
        }
    }

    /// Provides the use case for fetching user detail
    var userUseCase: Factory<GetUserDetailUseCase> {
        self {
            GetUserDetailUseCaseImpl(userRepository: self.userRepository())
        }
    }
}
