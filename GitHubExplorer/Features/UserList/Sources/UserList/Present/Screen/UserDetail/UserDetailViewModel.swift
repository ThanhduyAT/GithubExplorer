//
//  UserDetailViewModel.swift
//  UserDetail
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

@MainActor
@Observable class UserDetailViewModel {

    // MARK: - Input
    let userName: String

    // MARK: - Output
    var user: UserDetail?
    var isLoading: Bool = false
    var error: Error?

    // MARK: - Dependencies
    private var userUsecase: GetUserDetailUseCase

    // MARK: - Init
    init(userName: String, factory: UserDetailFactory) {
        self.userName = userName
        self.userUsecase = factory.makeUserUseCase()
    }

    // MARK: - Public API
    func getUserDetail() async {
        isLoading = true
        defer { isLoading = false }

        do {
            user = try await userUsecase.execute(userName: userName)
        } catch {
            self.error = error
        }
    }
}
