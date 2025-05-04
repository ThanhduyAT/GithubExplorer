//
//  KeychainHelper.swift
//  Common
//
//  Created by Duy Thanh on 2/5/25.
//

import Security
import Foundation

public class KeychainHelper: @unchecked Sendable {
    public static let shared = KeychainHelper()

    public init() {}

    public func save(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataConversionError
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        // Delete existing data if present
        SecItemDelete(query as CFDictionary)

        // Save new data
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailure(status)
        }
    }

    public func read(key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw KeychainError.readFailure(status)
        }
        guard let data = item as? Data,
              let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.dataConversionError
        }
        return string
    }

    public func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

public enum KeychainError: Error, LocalizedError {
    case saveFailure(OSStatus)
    case readFailure(OSStatus)
    case deleteFailure(OSStatus)
    case itemNotFound
    case dataConversionError
    public var errorDescription: String? {
        switch self {
        case .saveFailure(let status):
            return "Failed to save to Keychain: \(status)"
        case .readFailure(let status):
            return "Failed to read from Keychain: \(status)"
        case .deleteFailure(let status):
            return "Failed to delete from Keychain: \(status)"
        case .itemNotFound:
            return "Item not found in Keychain"
        case .dataConversionError:
            return "Failed to convert data"
        }
    }
}
