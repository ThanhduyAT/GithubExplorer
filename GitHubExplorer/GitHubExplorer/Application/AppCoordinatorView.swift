//
//  AppCoordinatorView.swift
//  GitHubExplorer
//
//  Created by Duy Thanh on 2/5/25.
//

import SwiftUI
import Authorization

struct AppCoordinatorView: View {
    @StateObject var session = SessionManager()
    var body: some View {
        Group {
            if session.isLoggedIn {
                HomeCoordinatorView()
            } else {
                AuthCoordinatorView(authCoordinator: AuthCoordinator(sessionManager: session))
            }
        }
        .onAppear {
            session.checkLoggedIn()
        }
        .environmentObject(session)
    }
}
