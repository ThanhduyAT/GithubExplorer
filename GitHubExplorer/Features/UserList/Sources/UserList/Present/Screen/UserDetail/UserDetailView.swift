//
//  UserDetailView.swift
//  UserDetail
//
//  Created by Duy Thanh on 1/5/25.
//

import SwiftUI
import CommonUI

struct UserDetailView: View {
    @State private var viewModel: UserDetailViewModel

    init(viewModel: UserDetailViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                content
            }
        }
        .navigationTitle("User Detail")
        .task {
            await viewModel.getUserDetail()
        }
        .errorAlert(error: $viewModel.error)
    }

    // MARK: - Content Section
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            skeletonContent
        } else {
            detailContent
        }
    }

    private var detailContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            userCard
            followerInfo
            blogInfo
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var skeletonContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            UserCardSkeletonView()
                .redacted(reason: .placeholder)
                .shimmering()

            HStack {
                Spacer()
                IconSkeletonView()
                    .redacted(reason: .placeholder)
                    .shimmering()
                Spacer()
                IconSkeletonView()
                    .redacted(reason: .placeholder)
                    .shimmering()
                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 24)
                    .shimmering()

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .shimmering()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var userCard: some View {
        UserCardView(
            id: "",
            imageString: viewModel.user?.avatarUrl ?? "",
            username: viewModel.user?.login ?? "",
            detailString: viewModel.user?.location ?? ""
        )
        .padding(.bottom)
    }

    private var followerInfo: some View {
        HStack {
            Spacer()
            IconView(
                imageName: "person.2.fill",
                count: viewModel.user?.followers ?? 0,
                typeName: "Follower"
            )
            Spacer()
            IconView(
                imageName: "medal.star.fill",
                count: viewModel.user?.following ?? 0,
                typeName: "Following"
            )
            Spacer()
        }
        .padding(.bottom)
    }

    private var blogInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Blog")
                .font(.title)
                .foregroundColor(.black)

            Text(viewModel.user?.htmlUrl ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
