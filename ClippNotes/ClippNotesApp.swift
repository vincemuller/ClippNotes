//
//  ClippNotesApp.swift
//  ClippNotes
//
//  Created by Vince Muller on 4/8/25.
//

import SwiftUI


@main
struct ClippNotesApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            CustomerListScreen()
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.configureAmplify()
                    Task {
                        await viewModel.getCustomers()
                    }
                }
        }

    }

}
