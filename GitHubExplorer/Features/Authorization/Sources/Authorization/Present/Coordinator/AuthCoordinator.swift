//
//  AuthCoordinator.swift
//  Authorization
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation
import SwiftUI
import Common
import Factory

// Defines all authentication-related screens in the navigation stack
public enum AuthScreen: Identifiable, Hashable {
    case login
    public var id: Self { return self }
}

// Protocol to manage login session actions (e.g., saving tokens, updating state)
public protocol SessionManaging {
    func loggedIn()
}

@Observable
public final class AuthCoordinator: StackNavigatable {
    public typealias ScreenType = AuthScreen
    // Manages session state (e.g., notifying app that login succeeded)
    private var sessionManager: SessionManaging
    // Provides dependencies for login (e.g., use case)
    let loginUseCase: LoginFactory = Container.shared
    // Keeps track of navigation path for stack-based navigation
    public var path: NavigationPath = NavigationPath()

    public init(sessionManager: SessionManaging) {
        self.sessionManager = sessionManager
    }
}

// MARK: - Navigation Actions

extension AuthCoordinator {
    public func push(_ screen: ScreenType) {
        path.append(screen)
    }
    public func pop() {
        path.removeLast()
    }
    public func popToRoot() {
        path.removeLast(path.count)
    }
}

// MARK: - View Building
@MainActor
extension AuthCoordinator {
    @ViewBuilder
    public func build(_ screen: AuthScreen) -> some View {
        switch screen {
        case .login:
            // Create login view with injected dependencies and callback
            let viewModel = LoginViewModel(factory: loginUseCase) { [weak self] in
                self?.sessionManager.loggedIn()
            }
            LoginView(viewModel: viewModel)
        }
    }
}
