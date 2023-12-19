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
    
    @Binding var currentGameState: GameState
    @State var name: String = ""
    @Binding var scores: [Score]
    let saveAction: ()-> Void
    @State var check = false
//    var score: Int
    
   @StateObject var gameLogic: ArcadeGameLogic =  ArcadeGameLogic.shared
    
    var body: some View {
        if check {
            LeaderBoardView(scores: scores)
                .onTapGesture {
                    backToMainScreen()
                }
        } else {
            ZStack {
                Image("title")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Text("Your name: ")
                        .background(
                            Image("wood")
                                .resizable()
                                .frame(width: 220, height: 45)
                        )
                        .font(Font.custom("Daydream", size: 15))
                        .foregroundColor(.black)
                        //.padding(.top, 130)
                    
                    TextField("Name", text: $name)
                        .frame(width: 300)
                        .background(Color(.ground))
                        .padding(15)
                    
                    Button {
                        print(name + " \(gameLogic.currentScore)")
                        scores.append(Score(name: name, points: gameLogic.currentScore))
                        self.saveAction()
                        check.toggle()
                    } label: {
                        Text("Submit")
                            .font(Font.custom("Daydream", size: 15))
                    }
                    .background(
                        Image("wood2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 125, height: 25)
                    )
                    .foregroundColor(.black)
                    .padding(.top, 50)
                    
                    
                    HStack {
                        Button {
                            withAnimation { self.backToMainScreen() }
                        } label: {
                            Text("Back to title")
                                .font(Font.custom("Daydream", size: 15))
                                .foregroundColor(.white)
                        }
                        .background(
                            Image("wood2")
                                .resizable()
                                .frame(width: 200, height: 50)
                        )
                        .padding(100)
                        
                        Button {
                            withAnimation { self.restartGame() }
                        } label: {
                            Text("Play again")
                                .font(Font.custom("Daydream", size: 15))
                                .foregroundColor(.white)
                        }
                        .background(
                            Image("wood2")
                                .resizable()
                                .frame(width: 200, height: 50)
                        )
                        .padding(100)
                    }
                    
                    //Old code
                    
                    
    //                
    //                Spacer()
    //                
                    
    //                
    //                Spacer()
                }
                .offset(y: 55)
            }
            .statusBar(hidden: true)
        }
    }
    
    private func backToMainScreen() {
        self.currentGameState = .mainScreen
    }
    
    private func restartGame() {
        self.currentGameState = .playing
    }
}

#Preview {
    GameOverView(currentGameState: .constant(GameState.gameOver), scores: .constant([
    ])) {}
}
