//
//  File.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import Foundation

@MainActor
@Observable
class UserListViewModel {
    var users: [User] = []
    var isLoadingMore: Bool = false
    var sinceId: Int = 100
    var usersPerPage: Int = 20
    var error: Error?

    private var usersUseCase: FetchUsersUseCase

    public init(factory: UserListFactory) {
        self.usersUseCase = factory.makeUsersUseCase()
    }

    func fetchUsers() async {
        guard !isLoadingMore else { return }

        isLoadingMore = true
        let query = UserListQuery(since: String(sinceId), perPage: String(usersPerPage))

        do {
            let result = try await usersUseCase.execute(query: query)
            users.append(contentsOf: result)
            if let lastId = result.last?.id {
                sinceId = lastId
            }
        } catch {
            self.error = error
        }

        isLoadingMore = false
    }
}

