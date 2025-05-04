//
//  UserStorageTests.swift
//  UserList
//
//  Created by Duy Thanh on 4/5/25.
//

import SwiftData
import Testing
@testable import UserList

struct UserStorageTests {
    @Test
    func testSaveAndFetchUsers() async throws {
        // Given: A temporary in-memory model container and actor
        let schema = Schema([UserPersistent.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: config)

        // Inject modelContext manually for testing
        let actor = UserStorageImpl(modelContainer: container)
        let testUsers = [
            User(
                id: 100,
                login: "ThanhDuy",
                avatarUrl: "https://avatars.githubusercontent.com/u/119?v=4",
                htmlUrl: "https://github.com/ThanhduyAT"
            ),
            User(
                id: 101,
                login: "peterc",
                avatarUrl: "https://avatars.githubusercontent.com/u/118?v=4",
                htmlUrl: "https://github.com/peterc"
            )
        ]

        // When: Save users
        try await actor.saveUsers(testUsers)

        // Then: Fetch and assert
        let fetchedUsers = try await actor.fetchUsers()
        #expect(fetchedUsers.count == 2)
        #expect(fetchedUsers.first?.id == 100)
    }
}
