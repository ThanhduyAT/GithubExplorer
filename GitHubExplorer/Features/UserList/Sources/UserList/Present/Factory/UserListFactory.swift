//
//  UserListFactory.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation
import Factory

// Protocol to define the creation of the FetchUsers use case
protocol UserListFactory {
    // Method to create and return the FetchUsersUseCase
    func makeUsersUseCase() -> FetchUsersUseCase
}

// Extension to implement the UserListFactory protocol using the Container
extension Container: UserListFactory {
    // Implements the method to return the shared instance of FetchUsersUseCase
    func makeUsersUseCase() -> FetchUsersUseCase {
        return usersUseCase.shared()  // Assuming 'usersUseCase' is a shared instance
    }
}
