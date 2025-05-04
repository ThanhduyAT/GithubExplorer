//
//  GetUserDetailUseCaseTests.swift
//  UserList
//
//  Created by Duy Thanh on 4/5/25.
//

import Testing
@testable import UserList

struct GetUserDetailUseCaseTests {

    @Test
    func testExecuteReturnsUserDetail() async throws {
        // Arrange
        let mockRepository = MockUserRepository()
        let expected = UserDetail(
            login: "ThanhDuy",
            avatarUrl: "https://avatars.githubusercontent.com/u/119?v=4",
            htmlUrl: "https://github.com/ThanhduyAT",
            location: "Viet Nam",
            followers: 1000,
            following: 1000
        )
        mockRepository.expectedUserDetail = expected
        let useCase = GetUserDetailUseCaseImpl(userRepository: mockRepository)
        
        // Act
        let result = try await useCase.execute(userName: "ThanhDuy")
        
        // Assert
        #expect(result.login == expected.login)
        #expect(mockRepository.receivedUsername == "ThanhDuy")
    }

    @Test
    func testExecuteThrowsErrorWhenRepositoryFails() async {
        // Arrange
        let mockRepository = MockUserRepository()
        mockRepository.expectedUserDetail = nil // Simulate failure
        let useCase = GetUserDetailUseCaseImpl(userRepository: mockRepository)
        
        // Act & Assert
        do {
            _ = try await useCase.execute(userName: "unknown")
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(true)
        }
    }
}
