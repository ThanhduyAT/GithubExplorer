//
//  FetchUsersUseCaseTests.swift
//  UserList
//
//  Created by Duy Thanh on 4/5/25.
//


import Testing
import Factory
@testable import UserList

struct FetchUsersUseCaseTests {
    @Test
    func testExecuteReturnsExpectedUsers() async throws {
        // Arrange
        let mockRepo = MockUserRepository()
        mockRepo.expectedResult = [
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

        // Override Factory for testing
        Container.shared.userRepository.register { mockRepo }

        let useCase = FetchUsersUseCaseImpl(userRepository: Container.shared.userRepository())
        let query = UserListQuery(since: "100", perPage: "20")

        // Act
        let result = try await useCase.execute(query: query)

        // Assert
        #expect(mockRepo.fetchUserListCalled == true)
        #expect(!result.isEmpty)
    }
}
