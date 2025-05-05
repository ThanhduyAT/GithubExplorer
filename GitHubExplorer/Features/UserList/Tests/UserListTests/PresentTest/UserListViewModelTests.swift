//
//  UserListViewModelTests.swift
//  UserList
//
//  Created by Duy Thanh on 4/5/25.
//

import Testing
import Factory
import Foundation
@testable import UserList

struct UserListViewModelTests {
    let mockUsers = [
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
    
    // MARK: - Tests
    @MainActor
    @Test("fetchUsers appends users on success")
    func testFetchUsersSuccess() async {
        let mockUseCase = MockFetchUsersUseCase(users: mockUsers, error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        await viewModel.fetchUsers()
        
        #expect(viewModel.users.first?.id == mockUsers.first?.id)
        #expect(viewModel.sinceId == 101) // Last user's ID
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.isRequestPending == false)
        #expect(viewModel.error == nil)
    }

    @MainActor
    @Test("fetchUsers handles errors")
    func testFetchUsersError() async {
        struct TestError: Error {}
        let mockUseCase = MockFetchUsersUseCase(users: [], error: TestError())
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        await viewModel.fetchUsers()
        
        #expect(viewModel.users.isEmpty)
        #expect(viewModel.sinceId == 100) // Unchanged
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.isRequestPending == false)
        #expect(viewModel.error is TestError)
    }
    
    @MainActor
    @Test("fetchUsers does nothing when loading or pending")
    func testFetchUsersGuardConditions() async {
        let mockUseCase = MockFetchUsersUseCase(users: mockUsers, error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        // Set guard conditions
        viewModel.isLoadingMore = true
        await viewModel.fetchUsers()
        #expect(viewModel.users.isEmpty)
        
        viewModel.isLoadingMore = false
        viewModel.isRequestPending = true
        await viewModel.fetchUsers()
        #expect(viewModel.users.isEmpty)
    }
    
    @MainActor
    @Test("fetchUsersDebounced fetches after delay")
    func testFetchUsersDebounced() async {
        let mockUseCase = MockFetchUsersUseCase(users: mockUsers, error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        viewModel.fetchUsersDebounced(debounceTime: 0.1)
        try? await Task.sleep(nanoseconds: 200_000_000) // Wait for debounce
        #expect(viewModel.users.first?.id == mockUsers.first?.id)
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.isRequestPending == false)
    }
    
    @MainActor
    @Test("fetchUsersDebounced cancels previous task")
    func testFetchUsersDebouncedCancellation() async {
        let mockUseCase = MockFetchUsersUseCase(users: [], error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        viewModel.fetchUsersDebounced(debounceTime: 1.0) // Long delay
        viewModel.fetchUsersDebounced(debounceTime: 0.1) // Override with short delay
        try? await Task.sleep(nanoseconds: 200_000_000) // Wait for second debounce
        #expect(viewModel.users.isEmpty) // Should only fetch once
        #expect(viewModel.isLoadingMore == false)
    }
    
    @MainActor
    @Test("resetPagination clears state and fetches")
    func testResetPagination() async {
        let mockUseCase = MockFetchUsersUseCase(users: mockUsers, error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        // Set initial state
        viewModel.users = mockUsers
        viewModel.sinceId = 200
        
        viewModel.resetPagination()
        try? await Task.sleep(nanoseconds: 100_000_000) // Wait for fetch
        
        #expect(viewModel.users.first?.id == mockUsers.first?.id)
        #expect(viewModel.sinceId == 101)
        #expect(viewModel.isLoadingMore == false)
    }
    
    @MainActor
    @Test("handleInitialLoadIfNeeded fetches only once")
    func testHandleInitialLoadIfNeeded() async {
        let mockUseCase = MockFetchUsersUseCase(users: mockUsers, error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        await viewModel.handleInitialLoadIfNeeded()
        #expect(viewModel.users.first?.id == mockUsers.first?.id)
        #expect(viewModel.didAppear == true)
        
        await viewModel.handleInitialLoadIfNeeded() // Should do nothing
        #expect(viewModel.users.first?.id  == mockUsers.first?.id) // No additional fetch
    }
    
    @MainActor
    @Test("handleItemAppear triggers fetch near end")
    func testHandleItemAppear() async {
        let mockUseCase = MockFetchUsersUseCase(users: mockUsers, error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        // Set up users (need at least 3 for count - 3 check)
        viewModel.users = (100...104).map {
            User(
                id: $0,
                login: "ThanhDuy",
                avatarUrl: "https://avatars.githubusercontent.com/u/119?v=4",
                htmlUrl: "https://github.com/ThanhduyAT"
            )
        }
        
        viewModel.handleItemAppear(user: viewModel.users[2]) // Index 2 == count - 3
        try? await Task.sleep(nanoseconds: 400_000_000) // Wait for debounce
        
        #expect(viewModel.users.count == 7) // 5 + 2 from fetch
    }
    
    @MainActor
    @Test("prefetchImages returns correct URLs")
    func testPrefetchImages() {
        let mockUseCase = MockFetchUsersUseCase(users: mockUsers, error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        viewModel.users = mockUsers
        
        let urls = viewModel.prefetchImages(for: 0, prefetchCount: 3)
        let expectedUrls = [
            URL(string: "https://avatars.githubusercontent.com/u/118?v=4")!,
        ]
        
        #expect(urls.last?.absoluteString == expectedUrls.last?.absoluteString)
    }
    
    @MainActor
    @Test("prefetchImages returns empty for out of bounds")
    func testPrefetchImagesReturnsEmptyWhenAtLastElement() {
        let mockUseCase = MockFetchUsersUseCase(users: mockUsers, error: nil)
        let factory = MockUserListFactory(useCase: mockUseCase)
        let viewModel = UserListViewModel(factory: factory)
        
        viewModel.users = mockUsers
        
        let urls = viewModel.prefetchImages(for: 1, prefetchCount: 5) // Beyond users.count
        #expect(urls.count == 1)
    }
}

extension UserListViewModelTests {
    struct MockFetchUsersUseCase: FetchUsersUseCase {
        let users: [User]
        let error: Error?
        
        func execute(query: UserListQuery) async throws -> [User] {
            if let error {
                throw error
            }
            return users
        }
    }

    struct MockUserListFactory: UserListFactory {
        let useCase: FetchUsersUseCase
        
        func makeUsersUseCase() -> FetchUsersUseCase {
            return useCase
        }
    }
}
