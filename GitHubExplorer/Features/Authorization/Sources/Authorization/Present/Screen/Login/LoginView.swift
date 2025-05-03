//
//  GitHubLoginView.swift
//  Authorization
//
//  Created by Duy Thanh on 2/5/25.
//

import SwiftUI
import AuthenticationServices
import CommonUI

struct LoginView: View {
    // MARK: - State
    @State private var viewModel: LoginViewModel
    @StateObject private var presentationContextProvider = PresentationContextProvider()

    // MARK: - Init
    init(viewModel: LoginViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - View
    var body: some View {
        VStack {
            loginButton
        }
        .errorAlert(error: $viewModel.error)
    }

    // MARK: - Components
    private var loginButton: some View {
        Button(action: openWebView) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                Text("Login with GitHub")
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }

    // MARK: - GitHub Auth
    private func openWebView() {
        if let url = viewModel.openGitHubLogin() {
            let scheme = "githubexplorer"
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
                if let error {
                    viewModel.error = error
                    return
                }
                
                if let callbackURL = callbackURL,
                   let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
                   let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                    // Exchange code for access token here
                    Task {
                        await viewModel.performLogin(code: code)
                    }
                }
            }
            
            session.presentationContextProvider = presentationContextProvider
            session.start()
        }
    }
}

class PresentationContextProvider: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }
        return keyWindow
    }
}
