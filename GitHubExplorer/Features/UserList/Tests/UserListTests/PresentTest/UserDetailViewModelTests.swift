//
//  UserDetailViewModelTests.swift
//  UserList
//
//  Created by Duy Thanh on 4/5/25.
//

import Testing
import Factory
import Foundation
@testable import UserList

struct UserDetailViewModelTests {
    let mockUser = UserDetail(
        login: "ThanhDuy",
        avatarUrl: "https://avatars.githubusercontent.com/u/119?v=4",
        htmlUrl: "https://github.com/ThanhduyAT",
        location: "Viet Nam",
        followers: 1000,
        following: 1000
    )
    
    // MARK: - Tests
    @MainActor
    @Test("getUserDetail fetches user on success")
    func testGetUserDetailSuccess() async {
        let mockUseCase = MockGetUserDetailUseCase(user: mockUser, error: nil)
        let factory = MockUserDetailFactory(useCase: mockUseCase)
        let viewModel = UserDetailViewModel(userName: "testuser", factory: factory)
        
        await viewModel.getUserDetail()
        
        #expect(viewModel.user == mockUser)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
    }
    
    @MainActor
    @Test("getUserDetail handles errors")
    func testGetUserDetailError() async {
        struct TestError: Error {}
        let mockUseCase = MockGetUserDetailUseCase(user: nil, error: TestError())
        let factory = MockUserDetailFactory(useCase: mockUseCase)
        let viewModel = UserDetailViewModel(userName: "testuser", factory: factory)
        
        await viewModel.getUserDetail()
        
        #expect(viewModel.user == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error is TestError)
    }
    
    @MainActor
    @Test("getUserDetail sets isLoading correctly")
    func testGetUserDetailLoadingState() async {
        let mockUseCase = MockGetUserDetailUseCase(user: mockUser, error: nil)
        let factory = MockUserDetailFactory(useCase: mockUseCase)
        let viewModel = UserDetailViewModel(userName: "testuser", factory: factory)
        
        // Start the fetch but don't await it yet
        let task = Task {
            viewModel.isLoading = true
            await viewModel.getUserDetail()
        }
        
        // Wait for fetch to complete
        await task.value
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.user == mockUser)
    }
    
    @MainActor
    @Test("getUserDetail sets isLoading correctly on error")
    func testGetUserDetailLoadingStateError() async {
        struct TestError: Error {}
        let mockUseCase = MockGetUserDetailUseCase(user: nil, error: TestError())
        let factory = MockUserDetailFactory(useCase: mockUseCase)
        let viewModel = UserDetailViewModel(userName: "testuser", factory: factory)
        
        // Start the fetch but don't await it yet
        let task = Task {
            viewModel.isLoading = true
            await viewModel.getUserDetail()
        }
        
        // Wait for fetch to complete
        await task.value
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error is TestError)
    }
}

extension UserDetailViewModelTests {
    struct MockGetUserDetailUseCase: GetUserDetailUseCase {
        let user: UserDetail?
        let error: Error?
        
        func execute(userName: String) async throws -> UserDetail {
            if let error {
                throw error
            }
            guard let user else {
                throw NSError(domain: "Mock", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user provided"])
            }
            return user
        }
    }

    struct MockUserDetailFactory: UserDetailFactory {
        let useCase: GetUserDetailUseCase
        
        func makeUserUseCase() -> GetUserDetailUseCase {
            return useCase
        }
    }
}
