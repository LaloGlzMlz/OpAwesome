//
//  GameOverView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameOverView
 *   This view is responsible for showing the game over state of the game.
 *  Currently it only present buttons to take the player back to the main screen or restart the game.
 *
 *  You can also present score of the player, present any kind of achievements or rewards the player
 *  might have accomplished during the game session, etc...
 **/

struct GameOverView: View {
    
    @State private var showingLeaderboard = true
    
    @Binding var currentGameState: GameState
    @State var name: String = ""
    @Binding var scores: [Score]
    let saveAction: ()-> Void
    @State var check = false
    //    var score: Int
    
    @StateObject var gameLogic: ArcadeGameLogic =  ArcadeGameLogic.shared
    
    var body: some View {
        if check {
            LeaderBoardView(scores: scores, isPresented: $showingLeaderboard)
                .onTapGesture {
                    backToMainScreen()
                }
        } else {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Text("Your name:")
                    
                    TextField("Name", text: $name)
                    
                    Button("Oye") {
                        print(name + " \(gameLogic.currentScore)")
                        scores.append(Score(name: name, points: gameLogic.currentScore))
                        self.saveAction()
                        check.toggle()
                    }
                }
            }
            .statusBar(hidden: true)
        }
    }
    
    private func backToMainScreen() {
        self.currentGameState = .mainScreen
        //self.showingLeaderboard = false
        
    }
    
    private func restartGame() {
        self.currentGameState = .playing
    }
}

#Preview {
    GameOverView(currentGameState: .constant(GameState.gameOver), scores: .constant([
    ])) {}
}
