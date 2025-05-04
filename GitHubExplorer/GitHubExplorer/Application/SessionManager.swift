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
        if checkAccessToken() {
            isLoggedIn = true
            return
        }
        isLoggedIn = false
    }
    
    private func checkAccessToken() -> Bool {
        do {
            let token = try AuthenticationService().getToken()
            return token != nil
        } catch {
            return false
        }
    }
}
