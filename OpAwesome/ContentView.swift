//
//  ContentView.swift
//  OpAwesome
//
//  Created by Eduardo Gonzalez Melgoza on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    
    
    @Binding var scores: [Score]
    let saveAction: ()-> Void
    
    // The navigation of the app is based on the state of the game.
    // Each state presents a different view on the SwiftUI app structure
    @State var currentGameState: GameState = .playing
    
    // The game logic is a singleton object shared among the different views of the application
    @StateObject var gameLogic: ArcadeGameLogic = ArcadeGameLogic()
    
    var body: some View {
        
        switch currentGameState {
        case .mainScreen:
            MainScreenView(currentGameState: $currentGameState)
                .environmentObject(gameLogic)
        
        case .playing:
            ArcadeGameView(currentGameState: $currentGameState)
                .environmentObject(gameLogic)
        
        case .gameOver:
            GameOverView(currentGameState: $currentGameState, scores: $scores, saveAction: saveAction)
                .environmentObject(gameLogic)
        }
    }
}

#Preview {
    ContentView(scores: .constant([])) {}
}
