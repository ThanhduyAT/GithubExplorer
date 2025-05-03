//
//  ErrorAlertModifier.swift
//  Common
//
//  Created by Duy Thanh on 3/5/25.
//

import SwiftUI

public struct ErrorAlertModifier: ViewModifier {
    @Binding var error: Error?

    public func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: Binding<Bool>(
                get: { error != nil },
                set: { if !$0 { error = nil } }
            )) {
                Button("OK", role: .cancel) { error = nil }
            } message: {
                Text(error?.localizedDescription ?? "An unknown error occurred.")
            }
    }
}

public extension View {
    func errorAlert(error: Binding<Error?>) -> some View {
        self.modifier(ErrorAlertModifier(error: error))
    }
}
