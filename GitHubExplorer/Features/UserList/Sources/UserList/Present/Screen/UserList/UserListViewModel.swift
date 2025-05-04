//
//  UserListViewModel.swift
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

    private var isRequestPending = false
    private var debounceTask: Task<Void, Never>?
    private var usersUseCase: FetchUsersUseCase

    public init(factory: UserListFactory) {
        self.usersUseCase = factory.makeUsersUseCase()
    }

    func fetchUsers() async {
        guard !isLoadingMore && !isRequestPending else { return }
        isRequestPending = true
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
        isRequestPending = false
        isLoadingMore = false
    }

    func fetchUsersDebounced(debounceTime: TimeInterval = 0.3) {
        // Cancel previous debounce task if exists
        debounceTask?.cancel()

        // Create new debounce task
        debounceTask = Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(debounceTime * 1_000_000_000))
                if !Task.isCancelled && !isRequestPending {
                    await fetchUsers()
                }
            } catch {
                // Task was cancelled, do nothing
            }
        }
    }

    func resetPagination() {
        users = []
        sinceId = 100
        isLoadingMore = false
    }
}
