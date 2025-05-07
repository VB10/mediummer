//
//  CleanTextHomeView.swift
//  MediummerIOS
//
//  Created by vb10 on 7.05.2025.
//

import SwiftUI

internal struct UserInput {
    @CleanText(maxLength: 20, fallback: "Anonim")
    var name: String = ""

    @CleanText(maxLength: 40, fallback: "noemail@example.com")
    var email: String = ""
}

struct CleanTextHomeView: View {
    let user = UserInput(name: "   Veli   ", email: "  veli@example.com     ")

    var body: some View {
        Text("\(user.name) (\(user.email))")
    }
}

#Preview {
    CleanTextHomeView()
}
