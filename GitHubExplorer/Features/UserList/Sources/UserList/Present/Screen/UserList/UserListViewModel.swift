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
    // MARK: - Public Properties
    var error: Error?
    var isLoadingMore: Bool = false
    var isRequestPending = false
    var users: [User] = []
    var sinceId: Int = 100
    private(set) var usersPerPage: Int = 20
    private(set) var didAppear = false

    // MARK: - Private Properties
    private var debounceTask: Task<Void, Never>?
    private var usersUseCase: FetchUsersUseCase

    // MARK: - Initialization
    public init(factory: UserListFactory) {
        self.usersUseCase = factory.makeUsersUseCase()
    }

    // MARK: - Public Methods
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
        debounceTask?.cancel()
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
        Task { await fetchUsers() }
    }

    func handleInitialLoadIfNeeded() async {
        guard !didAppear else { return }
        didAppear = true
        await fetchUsers()
    }

    func handleItemAppear(user: User) {
        if let index = users.firstIndex(where: { $0.id == user.id }),
           index == users.count - 3 {
            fetchUsersDebounced()
        }
    }

    // MARK: - Prefetch Images
    /// Prefetch avatar image URLs for upcoming users to improve UX.
    /// - Parameters:
    ///   - displayedUsers: Currently visible users.
    ///   - prefetchCount: Number of users ahead to prefetch images for.
    /// - Returns: Array of avatar image URLs to prefetch.
    func prefetchImages(for displayedIndex: Int, prefetchCount: Int = 5) -> [URL] {
        let currentIndex = displayedIndex
        let endIndex = min(currentIndex + prefetchCount, users.count)
        if currentIndex < endIndex {
            return users[currentIndex..<endIndex].compactMap { URL(string: $0.avatarUrl) }
        }
        return []
    }
}
