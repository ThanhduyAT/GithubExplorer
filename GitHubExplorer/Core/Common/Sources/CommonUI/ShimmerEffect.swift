//
//  ShimmerEffect.swift
//  Common
//
//  Created by Duy Thanh on 3/5/25.
//

import SwiftUI

public extension View {
    func shimmering() -> some View {
        self
            .modifier(ShimmerEffect())
    }
}

public struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    public func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .white.opacity(0.4), .clear]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 200
                }
            }
    }
}
