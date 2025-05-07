//
//  MarkdownHomeView.swift
//  MediummerIOS
//
//  Created by vb10 on 7.05.2025.
//

import MarkdownUI
import SwiftUI

struct MarkdownHomeView: View {
    @Environment(\.openURL) var openURL
    let markdownVM = MarkdownViewModel()
    var body: some View {
        ScrollView {
            Markdown(markdownVM.content)
                .markdownTheme(.fancy)
                .padding()
        }
        .onOpenURL { url in
            markdownVM.onUrlTapped(url: url.description)
        }
    }
}

#Preview {
    MarkdownHomeView()
}
