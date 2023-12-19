//
//  OpAwesomeApp.swift
//  OpAwesome
//
//  Created by Eduardo Gonzalez Melgoza on 06/12/23.
//

import SwiftUI

@main
struct OpAwesomeApp: App {
    @StateObject private var store: Store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView(scores: $store.scores) {
                Task {
                    do {
                        try await store.save(scores: store.scores)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
            .task {
                do {
                    try await store.load()
                }
                catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
