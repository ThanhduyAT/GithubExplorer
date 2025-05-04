//
//  UserStorageImpl.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation
import SwiftData

@ModelActor
actor UserStorageImpl {}

extension UserStorageImpl: UserStorage {

    /// Saves an array of `User` domain models into persistent storage.
    /// - Parameter users: An array of domain `User` objects.
    func saveUsers(_ users: [User]) async throws {
        // Convert domain models to persistent models
        let usersPersistent = users.compactMap { UserPersistent(user: $0) }

        // Insert into the model context
        usersPersistent.forEach { modelContext.insert($0) }

        do {
            try modelContext.save()
            print("Saved \(usersPersistent.count) users")
        } catch {
            print("Save error: \(error)")
            throw error // Rethrow to allow upstream handling
        }
    }

    /// Fetches all users from persistent storage and maps them back to domain models.
    /// - Returns: An array of domain `User` objects.
    func fetchUsers() async throws -> [User] {
        let descriptor = FetchDescriptor<UserPersistent>(
            sortBy: [SortDescriptor(\.id)]
        )

        // Perform fetch and convert to domain models
        let usersPersistent = try? modelContext.fetch(descriptor)
        return usersPersistent?.compactMap { $0.toDomain() } ?? []
    }
}
