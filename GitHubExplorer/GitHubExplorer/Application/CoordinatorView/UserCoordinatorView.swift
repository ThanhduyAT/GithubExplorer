//
//  UserCoordinatorView.swift
//  GitHubExplorer
//
//  Created by Duy Thanh on 2/5/25.
//

import SwiftUI
import UserList

struct UserCoordinatorView: View {
    @State private var userCoordinator = UserCoordinator()
    
    var body: some View {
        NavigationStack(path: $userCoordinator.path) {
            userCoordinator.build(.userList)
                .navigationDestination(for: UserScreen.self) { route in
                    userCoordinator.build(route)
                }
        }
        .environment(userCoordinator)
    }
}
