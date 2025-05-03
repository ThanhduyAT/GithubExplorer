//
//  IconSkeletonView.swift
//  UserList
//
//  Created by Duy Thanh on 3/5/25.
//

import SwiftUI

struct IconSkeletonView: View {
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 64, height: 64)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 20)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 16)
        }
        .frame(width: 100)
    }
}
