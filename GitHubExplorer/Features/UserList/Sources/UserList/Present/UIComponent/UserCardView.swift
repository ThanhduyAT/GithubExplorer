//
//  UserCardView.swift
//  UserList
//
//  Created by Duy Thanh on 1/5/25.
//

import SwiftUI
import Kingfisher

struct UserCardView: View {
    let imageString: String
    let username: String
    let detailString: String

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            KFImage(URL(string: imageString))
                .placeholder {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                }
                .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 120, height: 120)))
                .cacheMemoryOnly()
                .diskCacheExpiration(.days(7))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 8) {
                Text(username)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(detailString)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .underline()
            }
            .padding(.vertical, 8)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    UserCardView(imageString: "", username: "Thanh duy", detailString: "https://duy.test.com")
}
