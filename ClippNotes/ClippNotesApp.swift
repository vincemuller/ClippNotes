//
//  ClippNotesApp.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/8/25.
//

import SwiftUI
import Amplify
import AWSPluginsCore
import AWSAPIPlugin


@main
struct ClippNotesApp: App {
    var body: some Scene {
        WindowGroup {
            ProfileScreen()
                .onAppear {
                    configureAmplify()
                }
        }

    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured!")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
    }
}
