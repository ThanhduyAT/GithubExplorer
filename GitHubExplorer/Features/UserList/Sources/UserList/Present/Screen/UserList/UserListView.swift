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
                    await viewModel.handleInitialLoadIfNeeded()
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

            Button(action: viewModel.resetPagination) {
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
        ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { index, user in
            UserCardView(
                imageString: user.avatarUrl,
                username: user.login,
                detailString: user.htmlUrl
            )
            .onTapGesture {
                coordinator.push(.userDetail(userName: user.login))
            }
            .onAppear {
                viewModel.handleItemAppear(user: user)
                prefetchImages(for: index)
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

    // MARK: - Prefetch images
    private func prefetchImages(for displayedIndex: Int, prefetchCount: Int = 5) {
        let prefetchUrls = viewModel.prefetchImages(for: displayedIndex, prefetchCount: prefetchCount)
        if !prefetchUrls.isEmpty {
            ImagePrefetcher(urls: Array(prefetchUrls)).start()
        }
    }
}
