//
//  File.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation
import SwiftUI
import Common
import Factory

// Enum defining the different screens for the user flow
public enum UserScreen: Identifiable, Hashable {
    case userList
    case userDetail(userName: String)
    
    public var id: Self { return self }
}

// Coordinator responsible for managing navigation and views in the user flow
@Observable
public final class UserCoordinator: StackNavigatable {
    // Define the associated type for screen navigation
    public typealias ScreenType = UserScreen
    
    // MARK: - Use Cases
    // Factories to get instances of use cases
    let usersUseCase: UserListFactory = Container.shared
    let userUseCase: UserDetailFactory = Container.shared
    
    // The navigation path for managing the navigation stack
    public var path: NavigationPath = NavigationPath()
    
    // Initializer for the coordinator
    public init() {}
}

// MARK: - Stack Navigation Methods
extension UserCoordinator {
    // Push a new screen onto the navigation stack
    public func push(_ screen: ScreenType) {
        path.append(screen)
    }
    
    // Pop the most recent screen from the navigation stack
    public func pop() {
        path.removeLast()
    }
    
    // Pop all screens and return to the root of the navigation stack
    public func popToRoot() {
        path.removeLast(path.count)
    }
}

// MARK: - View Building Methods
@MainActor
extension UserCoordinator {
    // Method to build the corresponding view for a given screen
    @ViewBuilder
    public func build(_ screen: UserScreen) -> some View {
        switch screen {
        // When the screen is 'userList', build the corresponding view with its ViewModel
        case .userList:
            let viewModel = UserListViewModel(factory: usersUseCase)
            UserListView(viewModel: viewModel)
        
        // When the screen is 'userDetail', build the corresponding view with the ViewModel passing the userName
        case let .userDetail(userName):
            let viewModel = UserDetailViewModel(userName: userName, factory: userUseCase)
            UserDetailView(viewModel: viewModel)
        }
    }
}
