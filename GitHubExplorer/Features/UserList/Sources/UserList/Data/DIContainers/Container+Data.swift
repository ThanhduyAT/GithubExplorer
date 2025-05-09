//
//  Container+Data.swift
//  UserList
//
//  Created by Duy Thanh on 2/5/25.
//

import Foundation
import Factory
import Networking
import SwiftData
import Moya
import Common

// MARK: - Dependency Injection Container Extension
public extension Container {
    /// Provides a configured `ModelContainer` for SwiftData persistence
    var modelContainer: Factory<ModelContainer> {
        self {
            // Define schema
            let schema = Schema([UserPersistent.self])

            // Define storage URL
            let storeURL = URL.applicationSupportDirectory
                .appending(path: "UserPersistent")

            // Configure model container
            let configuration = ModelConfiguration(url: storeURL, allowsSave: true)

            // Create container with error fallback
            guard let container = try? ModelContainer(for: schema, configurations: configuration) else {
                fatalError("❌ Failed to initialize ModelContainer")
            }

            return container
        }
    }

    /// Provides a concrete `UserStorage` implementation using SwiftData
    var userStorage: Factory<UserStorage> {
        self {
            UserStorageImpl(modelContainer: self.modelContainer())
        }
    }

    /// Provides a configured `UserApiClient` with authentication plugin
    var userApiClient: Factory<UserApiClient> {
        self {
            let baseURL = EnvironmentValues.baseUrl
            return UserApiClientImpl(baseURL: baseURL)
        }
    }

    /// Provides a concrete `UserRepository` implementation with API + local storage
    var userRepository: Factory<UserRepository> {
        self {
            UserRepositoryImpl(
                apiClient: self.userApiClient(),
                localStorage: self.userStorage()
            )
        }
    }
}
