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
                Color.white
                    .ignoresSafeArea()
        ZStack {
            Image("title")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Spacer()
                
                Button {
                    withAnimation { self.backToMainScreen() }
                } label: {
                    Text("Back to title screen")
                        .padding()
                        //.frame(maxWidth: 195)
                        .font(Font.custom("Daydream", size: 25))
                }
                .background(
                    Image("woddenPlank")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 220)
                )
                .foregroundColor(.black)
                //.background(.red)
                //.cornerRadius(10.0)
                .padding()
>>>>>>> Stashed changes
                
                VStack(alignment: .center) {
                    Text("Your name:")
                    
                    TextField("Name", text: $name)
                    
                    Button("Oye") {
                        print(name + " \(gameLogic.currentScore)")
                        scores.append(Score(name: name, points: gameLogic.currentScore))
                        self.saveAction()
                        check.toggle()
                    }
                    
                    //Old code
                    
                    
    //                Spacer()
    //                
    //                Button {
    //                    withAnimation { self.backToMainScreen() }
    //                } label: {
    //                    Image(systemName: "arrow.backward")
    //                        .foregroundColor(.black)
    //                        .font(.title)
    //                }
    //                .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
    //                
    //                Spacer()
    //                
    //                Button {
    //                    withAnimation { self.restartGame() }
    //                } label: {
    //                    Image(systemName: "arrow.clockwise")
    //                        .foregroundColor(.black)
    //                        .font(.title)
    //                }
    //                .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
    //                
    //                Spacer()
                }
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
