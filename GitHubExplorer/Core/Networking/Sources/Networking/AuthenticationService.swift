//
//  AuthenticationService.swift
//  Authorization
//
//  Created by Duy Thanh on 2/5/25.
//
import Common

public class AuthenticationService {
    public init() {}
    
    public func saveToken(_ token: String) throws {
        try KeychainHelper.shared.save(key: "accessToken", value: token)
    }

    public func getToken() throws -> String? {
        return try KeychainHelper.shared.read(key: "accessToken")
    }
    
    public func deleteToken() {
        return KeychainHelper.shared.delete(key: "accessToken")
    }
}
