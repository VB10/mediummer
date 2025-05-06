//
//  ComponentKitLogin.swift
//  MediummerIOS
//
//  Created by vb10 on 6.05.2025.
//

import ComponentsKit
import SwiftUI

struct ComponentKitLogin: View {
    @FocusState private var isEmailFieldFocused: Bool
    @State private var viewModel = ComponentKitLoginVM()
    private let ui = ComponentKitLoginUIModels()

    var body: some View {
        VStack(spacing: 24) {
            SUInputField(
                text: Binding(
                    get: { viewModel.email },
                    set: { viewModel.updateEmail($0) }
                ),
                model: ui.emailFieldModel
            )
            .focused($isEmailFieldFocused)

            SUInputField(
                text: Binding(
                    get: { viewModel.password },
                    set: { viewModel.updatePassword($0) }
                ),
                model: ui.passwordFieldModel
            )

            SUButton(model: ui.loginButtonModel, action: {
                Task {
                    await viewModel.login()
                }
            })

            if viewModel.isLoading {
                SUProgressBar(model: ui.progressBarModel)
                    .padding(.horizontal)
                
            }
        }
        .padding()
        .disabled(viewModel.isLoading)
        .suAlert(
            isPresented: $viewModel.isAlertPresented,
            model: ui.alertModel(message: viewModel.alertMessage ?? ""),
            primaryAction: {
                viewModel.resetAlert()
            },
            secondaryAction: {
                viewModel.resetAlert()
            },
            onDismiss: {
                viewModel.resetAlert()
            }
        )
    }
}

#Preview {
    ComponentKitLogin()
}
