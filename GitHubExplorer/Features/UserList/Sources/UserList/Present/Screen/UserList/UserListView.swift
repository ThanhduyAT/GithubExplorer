//
//  UserListView.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import CommonUI
import SwiftUI
import Kingfisher

struct UserListView: View {
    // MARK: - Dependencies
    @Environment(UserCoordinator.self) private var coordinator

    // MARK: - State
    @State var viewModel: UserListViewModel
    @State private var didAppear = false

    // MARK: - Init
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Github Users")
                .refreshable {
                    viewModel.resetPagination()
                    await viewModel.fetchUsers()
                }
                .task {
                    await handleInitialLoadIfNeeded()
                }
                .onAppear {
                    prefetchImages(for: viewModel.users)
                }
                .errorAlert(error: $viewModel.error)
        }
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        if viewModel.users.isEmpty && viewModel.isLoadingMore {
            // Skeleton loading
            loadingStateView
        } else if viewModel.users.isEmpty {
            // Empty state
            emptyStateView
        } else {
            // Loaded state
            List {
                userListSection
                loadingIndicator
            }
            .listStyle(.plain)
        }
    }

    // MARK: - Skeleton loading
    private var loadingStateView: some View {
        List {
            ForEach(0..<5, id: \.self) { _ in
                UserCardSkeletonView()
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
        .listStyle(.plain)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)

            Text("No users found.")
                .font(.headline)
                .foregroundColor(.gray)

            Button(action: resetPagination) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Sections
    private var userListSection: some View {
        ForEach(viewModel.users, id: \.id) { user in
            UserCardView(
                imageString: user.avatarUrl,
                username: user.login,
                detailString: user.htmlUrl
            )
            .onTapGesture {
                coordinator.push(.userDetail(userName: user.login))
            }
            .onAppear {
                handleItemAppear(user: user)
            }
            .listRowSeparator(.hidden)
        }
    }

    private var loadingIndicator: some View {
        Group {
            if viewModel.isLoadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
    }

    // MARK: - Load Methods
    private func resetPagination() {
        Task {
            viewModel.resetPagination()
            await viewModel.fetchUsers()
        }
    }

    private func handleInitialLoadIfNeeded() async {
        guard !didAppear else { return }
        didAppear = true
        await viewModel.fetchUsers()
    }

    private func handleItemAppear(user: User) {
        if let index = viewModel.users.firstIndex(where: { $0.id == user.id }),
           index == viewModel.users.count - 3 {
            viewModel.fetchUsersDebounced()
        }
    }

    private func prefetchImages(for displayedUsers: [User], prefetchCount: Int = 5) {
        // Calculate which images to prefetch
        let currentIndex = displayedUsers.count
        let endIndex = min(currentIndex + prefetchCount, viewModel.users.count)

        if currentIndex < endIndex {
            let prefetchUrls = viewModel.users[currentIndex..<endIndex].compactMap { URL(string: $0.avatarUrl) }

            // Prefetch images
            ImagePrefetcher(urls: Array(prefetchUrls)).start()
        }
    }
}
