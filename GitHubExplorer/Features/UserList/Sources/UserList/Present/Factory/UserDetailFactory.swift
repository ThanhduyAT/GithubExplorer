//
//  File.swift
//  UserList
//
//  Created by Duy Thanh on 2/5/25.
//

import Foundation
import Factory

// Protocol to define the creation of the UserDetail use case
protocol UserDetailFactory {
    // Method to create and return the GetUserDetailUseCase
    func makeUserUseCase() -> GetUserDetailUseCase
}

// Extension to implement the UserDetailFactory protocol using the Container
extension Container: UserDetailFactory {
    // Implements the method to return the shared instance of GetUserDetailUseCase
    func makeUserUseCase() -> GetUserDetailUseCase {
        return userUseCase.shared()  // Assuming 'userUseCase' is a shared instance
    }
}
