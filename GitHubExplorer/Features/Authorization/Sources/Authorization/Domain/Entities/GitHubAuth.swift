//
//  GitHubAuth.swift
//  Authorization
//
//  Created by Duy Thanh on 3/5/25.
//

import Foundation

struct GitHubAuth {
    let deviceCode: String
    let userCode: String
    let verificationUri: String
    let expiresIn: Int
    let interval: Int
}
