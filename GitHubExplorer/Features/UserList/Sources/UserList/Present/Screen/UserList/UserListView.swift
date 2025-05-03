//
//  SwiftUIView.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import CommonUI
import SwiftUI

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
                .task {
                    await handleInitialLoadIfNeeded()
                }
                .errorAlert(error: $viewModel.error)
        }
    }

    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        if viewModel.users.isEmpty && viewModel.isLoadingMore {
            // Skeleton loading
            List {
                ForEach(0..<5, id: \.self) { _ in
                    UserCardSkeletonView()
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
            }
            .listStyle(.plain)
        } else if viewModel.users.isEmpty {
            // Empty state
            VStack(spacing: 16) {
                Image(systemName: "person.crop.circle.badge.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)

                Text("No users found.")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            // Loaded state
            List {
                userListSection
                loadingIndicator
            }
            .listStyle(.plain)
        }
    }

    // MARK: - Sections
    private var userListSection: some View {
        ForEach(viewModel.users.indices, id: \.self) { index in
            let user = viewModel.users[index]
            UserCardView(
                id: String(user.id),
                imageString: user.avatarUrl,
                username: user.login,
                detailString: user.htmlUrl
            )
            .onTapGesture {
                coordinator.push(.userDetail(userName: user.login))
            }
            .onAppear {
                handleItemAppear(index: index)
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
    private func handleInitialLoadIfNeeded() async {
        guard !didAppear else { return }
        didAppear = true
        await viewModel.fetchUsers()
    }

    private func handleItemAppear(index: Int) {
        if index == viewModel.users.count - 1 {
            Task {
                await viewModel.fetchUsers()
            }
        }
    }
}
