//
//  ComponentKitLoginItems.swift
//  MediummerIOS
//
//  Created by vb10 on 6.05.2025.
//

import ComponentsKit

struct ComponentKitLoginUIModels {
    let emailFieldModel = InputFieldVM.init {
        $0.title = "Email"
        $0.placeholder = "Enter your email"
        $0.keyboardType = .emailAddress
    }

    let passwordFieldModel = InputFieldVM.init {
        $0.title = "Password"
        $0.placeholder = "Enter your password"
        $0.isSecureInput = true
    }

    let loginButtonModel = ButtonVM.init {
        $0.title = "Login"
        $0.style = .filled
        $0.size = .large
        $0.isFullWidth = true
    }

    let progressBarModel = ProgressBarVM {
        $0.currentValue = 65
        $0.cornerRadius = .large
        $0.style = .striped
        $0.color = .primary
    }

    func alertModel(message: String) -> AlertVM {
        .init {
            $0.title = "Login Result"
            $0.message = message
            $0.primaryButton?.title = "OK"
            $0.secondaryButton?.title = "Cancel"
        }
    }
}
