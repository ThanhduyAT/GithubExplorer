//
//  AuthCoordinatorView.swift
//  GitHubExplorer
//
//  Created by Duy Thanh on 2/5/25.
//

import SwiftUI
import Authorization

struct AuthCoordinatorView: View {
    @State private var authCoordinator: AuthCoordinator
    
    init(authCoordinator: AuthCoordinator) {
        self.authCoordinator = authCoordinator
    }
    
    var body: some View {
        NavigationStack(path: $authCoordinator.path) {
            authCoordinator.build(.login)
        }
        .environment(authCoordinator)
    }
}
