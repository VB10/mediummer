//
//  MediummerIOSApp.swift
//  MediummerIOS
//
//  Created by vb10 on 6.05.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct MediummerIOSApp: App {
    var body: some Scene {
        WindowGroup {
            TCAHomeView(
                store: Store(
                    initialState: TCAHomeFeature.State()
                ) {
                    TCAHomeFeature()
                }
            )
        }
    }
}
