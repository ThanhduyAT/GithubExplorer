//
//  UserCardSkeletonView.swift
//  UserList
//
//  Created by Duy Thanh on 3/5/25.
//


import SwiftUI

struct UserCardSkeletonView: View {
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 120, height: 16)
                    .foregroundColor(.gray.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 200, height: 14)
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
        .padding(.vertical, 8)
    }
}