//
//  UserRepositoryTests.swift
//  UserList
//
//  Created by Duy Thanh on 4/5/25.
//

import Testing
import SwiftData
import Factory
@testable import UserList

struct UserRepositoryTests {
    let localUser = UserDetailResponse(
        login: "ThanhDuy",
        avatarUrl: "https",
        htmlUrl: "https",
        location: "Viet Nam",
        followers: 1000,
        following: 1000,
        reposUrl: "",
        eventsUrl: ""
    )
    
    @Test
    func testGetUsersCallsApiWhenLocalHasSufficientDataAndCannotSave() async throws {
        // Given: it has 40 local data
        let mockStorage = MockUserStorage(modelContainer: Container.shared.modelContainer())
        let localUsers = (100...139).map {
            User(id: $0, login: "user\($0)", avatarUrl: "url\($0)", htmlUrl: "html\($0)")
        }
        try await mockStorage.saveUsers(localUsers)
        
        // Mock if it has data when calls api
        let apiUsers = (140...159).map {
            UserListResponse(
                id: $0,
                login: "apiUser\($0)",
                avatarUrl: "apiAvatarUrl\($0)",
                htmlUrl: "apiHttpUrl\($0)",
                url: "apiUrl\($0)",
                followersUrl: "followerUrl\(String($0))",
                followingUrl: "followingUrl\(String($0))"
            )
        }
        let mockApi = MockUserApiClient(usersToReturn: apiUsers, userDetailToReturn: localUser)
        let repo = UserRepositoryImpl(apiClient: mockApi, localStorage: mockStorage)
        
        // When
        let users = try await repo.getUsers(query: .init(since: "140", perPage: "20"))
        
        // Then
        #expect(users.count == 20)
        #expect(users.last?.login == "apiUser159")
    }
    
    @Test
    func testGetUsersReturnsLocalWhenSinceIs100AndHasSufficientData() async throws {
        // Given
        let mockStorage = MockUserStorage(modelContainer: Container.shared.modelContainer())
        let localUsers = (100...119).map {
            User(id: $0, login: "user\($0)", avatarUrl: "url\($0)", htmlUrl: "html\($0)")
        }
        try await mockStorage.saveUsers(localUsers)
        
        let mockApi = MockUserApiClient(usersToReturn: [], userDetailToReturn: localUser)
        let repo = UserRepositoryImpl(apiClient: mockApi, localStorage: mockStorage)

        // When
        let users = try await repo.getUsers(query: .init(since: "100", perPage: "20"))

        // Then
        #expect(users.count == 20)
        #expect(users.first?.id == 100)
    }
    
    @Test
    func testGetUsersCallsApiWhenLocalIsEmpty() async throws {
        // Given
        let mockStorage = MockUserStorage(modelContainer: Container.shared.modelContainer())
        try await mockStorage.saveUsers([])
        
        let apiUsers = (100...119).map {
            UserListResponse(
                id: $0,
                login: "apiUser\($0)",
                avatarUrl: "apiAvatarUrl\($0)",
                htmlUrl: "apiHttpUrl\($0)",
                url: "apiUrl\($0)",
                followersUrl: "followerUrl\(String($0))",
                followingUrl: "followingUrl\(String($0))"
            )
        }
        let mockApi = MockUserApiClient(usersToReturn: apiUsers, userDetailToReturn: localUser)
        let repo = UserRepositoryImpl(apiClient: mockApi, localStorage: mockStorage)

        // When
        let users = try await repo.getUsers(query: .init(since: "100", perPage: "20"))

        // Then
        #expect(users.count == 20)
        #expect(users.first?.login == "apiUser100")
    }

    @Test
    func testGetUserDetailReturnsConvertedUserDetail() async throws {
        // Given
        let mockStorage = MockUserStorage(modelContainer: Container.shared.modelContainer())
        let localUsers = (100...119).map {
            User(id: $0, login: "user\($0)", avatarUrl: "url\($0)", htmlUrl: "html\($0)")
        }
        try await mockStorage.saveUsers(localUsers)
        let mockApi = MockUserApiClient(usersToReturn: [], userDetailToReturn: localUser)
        let repo = UserRepositoryImpl(apiClient: mockApi, localStorage: mockStorage)

        // When
        let detail = try await repo.getUserDetail(userName: "ThanhDuy")

        // Then
        #expect(detail.location == "Viet Nam")
        #expect(detail.login == "ThanhDuy")
    }
}

extension UserRepositoryTests {
    struct MockUserApiClient: UserApiClient {
        let usersToReturn: [UserListResponse]
        let userDetailToReturn: UserDetailResponse

        func getUsers(request: UserListRequest) async throws -> [UserListResponse] {
            return usersToReturn
        }
        
        func getUserDetail(userName: String) async throws -> UserDetailResponse {
            userDetailToReturn
        }
    }
    
    @ModelActor
    actor MockUserStorage: UserStorage {
        var savedUsers: [User] = []

        func fetchUsers() async throws -> [User] {
            return savedUsers
        }

        func saveUsers(_ users: [User]) async throws {
            savedUsers.append(contentsOf: users)
        }
    }
}
