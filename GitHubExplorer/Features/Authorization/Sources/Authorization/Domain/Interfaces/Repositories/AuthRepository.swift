//
//  File.swift
//  Authorization
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

protocol AuthRepository {
    func openGitHubLogin() -> URL?
    func exchangeCodeForAccessToken(code: String) async throws
}
