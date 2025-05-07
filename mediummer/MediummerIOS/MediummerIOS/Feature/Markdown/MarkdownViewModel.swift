//
//  MarkdownViewModel.swift
//  MediummerIOS
//
//  Created by vb10 on 7.05.2025.
//

import MarkdownUI
import SwiftUI

struct MarkdownViewModel {
    let content = """
    # 🚀 Getting Started with Our App

    Welcome! This guide will help you understand the basics of using the app.

    ## 🔗 Useful Links

    - [Official Documentation](https://example.com/docs)
    - [Frequently Asked Questions](https://example.com/faq)
    - [GitHub Repository](https://github.com/gonzalezreal/swift-markdown-ui)

    ## 🧱 Example: SwiftUI Code

    ```swift
    import SwiftUI

    struct WelcomeView: View {
        var body: some View {
            Text("Welcome to the app!")
                .font(.title)
                .padding()
        }
    }
    ```

    ## 💡 Pro Tip

    > You can customize this app extensively using the **Settings** tab.

    ## 📞 Need Help?

    Reach out to our [Support Team](https://example.com/support). We're happy to help!
    """

    func onUrlTapped(url: String) {}
}


extension Theme {
    static let fancy = Theme()
        // Inline Style for `.code`
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
        }

        // Inline Style for `.link`
        .link {
            ForegroundColor(.purple)
        }

        // Block Style for `.paragraph`
        .paragraph { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.25))
                .markdownMargin(top: .zero, bottom: .zero)
        }

        // Block Style for `.listItem`
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: .em(0.25))
        }

        // Block Style for `.codeBlock`
        .codeBlock { configuration in
            ScrollView(.horizontal) {
                configuration.label
                    .relativeLineSpacing(.em(0.25))
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(.em(0.85))
                    }
                    .padding()
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .markdownMargin(top: .zero, bottom: .em(0.8))
        }

        // Block Style for `.heading1`
        .heading1 { configuration in
            VStack(alignment: .leading, spacing: 0) {
                configuration.label
                    .relativePadding(.bottom, length: .em(0.3))
                    .markdownMargin(top: .em(1.5), bottom: .em(1))
                    .markdownTextStyle {
                        FontFamily(.custom("Trebuchet MS"))
                        FontWeight(.semibold)
                        FontSize(.em(2))
                    }
                Divider()
            }
        }
}
