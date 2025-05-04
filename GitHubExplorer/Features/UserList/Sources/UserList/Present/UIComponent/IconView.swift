//
//  IconView.swift
//  UserList
//
//  Created by Duy Thanh on 2/5/25.
//

import Foundation
import SwiftUI

struct IconView: View {
    var imageName: String
    var count: Int
    var typeName: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())

            Text("\(count)")
                .font(.headline)
                .foregroundColor(.black)

            Text(typeName)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 100)
    }
}

#Preview {
    IconView(imageName: "person.2.fill", count: 100, typeName: "Follower")
}
