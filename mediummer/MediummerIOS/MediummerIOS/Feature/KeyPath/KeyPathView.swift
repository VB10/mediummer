//
//  KeyPathView.swift
//  MediummerIOS
//
//  Created by vb10 on 13.05.2025.
//

import SwiftUI

private struct User {
    var name: String
    var email: String
}

struct FormRow<T>: View {
    @Binding var model: T
    var keyPath: WritableKeyPath<T, String>
    var title: String

    var body: some View {
        HStack {
            Text(title)
            TextField(title, text: Binding(
                get: { model[keyPath: keyPath] },
                set: { model[keyPath: keyPath] = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}

struct KeyPathView: View {
    @State private var user = User(name: "", email: "")

    var body: some View {
        VStack(spacing: 16) {
            FormRow(model: $user, keyPath: \.name, title: "Ad")
            FormRow(model: $user, keyPath: \.email, title: "E-posta")

            Button("Gönder") {
                print("Ad: \(user.name), E-posta: \(user.email)")
            }
        }
        .padding()
    }
}

#Preview {
    KeyPathView()
}
