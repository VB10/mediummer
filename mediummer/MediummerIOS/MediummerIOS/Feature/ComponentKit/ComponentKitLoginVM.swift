//
//  ComponentKitLoginVM.swift
//  MediummerIOS
//
//  Created by vb10 on 6.05.2025.
//

import SwiftUI

@Observable
final class ComponentKitLoginVM {
    private enum LoginConstants {
        static let emailEmpty = "Please fill in all fields"
        static let invalidResponse = "Invalid credentials or response."
        static let success = "Login successful!"
    }

    private(set) var email = ""
    private(set) var password = ""
    private(set) var isLoading = false
    var alertMessage: String?
    var isAlertPresented = false

    func updateEmail(_ value: String) { email = value }
    func updatePassword(_ value: String) { password = value }

    func resetAlert() {
        alertMessage = nil
        isAlertPresented = false
    }

    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = LoginConstants.emailEmpty
            isAlertPresented = true
            return
        }

        isLoading = true
        defer { isLoading = false }

        let url = URL(string: "https://reqr.es/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode([
            "email": email,
            "password": password
        ])

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                alertMessage = LoginConstants.success
            } else {
                alertMessage = LoginConstants.invalidResponse
            }
        } catch {
            alertMessage = "Error: \(error.localizedDescription)"
        }

        isAlertPresented = true
    }
}
