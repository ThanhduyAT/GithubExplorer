//
//  SessionManager.swift
//  GitHubExplorer
//
//  Created by Duy Thanh on 2/5/25.
//

import Foundation
import Authorization
import Networking

@Observable
class SessionManager: ObservableObject {
    var isLoggedIn: Bool = false
    var authCode: String?
}

extension SessionManager: SessionManaging {
    func loggedIn() {
        isLoggedIn = true
    }
    
    func logout() {
        isLoggedIn = false
    }
    
    func checkLoggedIn() {
        let token = AuthenticationService().getToken()
        if token != nil {
            isLoggedIn = true
            return
        }
        isLoggedIn = false
    }
}
