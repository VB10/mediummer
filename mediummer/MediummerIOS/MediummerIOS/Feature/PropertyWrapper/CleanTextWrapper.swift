//
//  CleanTextWrapper.swift
//  MediummerIOS
//
//  Created by vb10 on 7.05.2025.
//

@propertyWrapper
struct CleanText {
    private let maxLength: Int
    private let fallback: String
    private var value: String = ""

    var wrappedValue: String {
        get { value }
        set {
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                value = fallback
            } else {
                value = String(trimmed.prefix(maxLength))
            }
        }
    }

    init(wrappedValue: String, maxLength: Int = 100, fallback: String = "N/A") {
        self.maxLength = maxLength
        self.fallback = fallback
        self.wrappedValue = wrappedValue
    }
}
