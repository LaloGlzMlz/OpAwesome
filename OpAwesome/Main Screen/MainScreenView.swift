//
//  MainScreen.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # MainScreenView
 *
 *   This view is responsible for presenting the game name, the game intructions and to start the game.
 *  - Customize it as much as you want.
 *  - Experiment with colors and effects on the interface
 *  - Adapt the "Insert a Coin Button" to the visual identity of your game
 **/

struct MainScreenView: View {
    
    @State var showingInstructions = false
    
    // The game state is used to transition between the different states of the game
    @Binding var currentGameState: GameState
    
    // Change it on the Constants.swift file
    var gameTitle: String = MainScreenProperties.gameTitle
    
    // Change it on the Constants.swift file
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    // Change it on the Constants.swift file
    let accentColor: Color = MainScreenProperties.accentColor
    
    var body: some View {
        
        ZStack {
            Image("title")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            Image("OpossumLeftFrame")
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.bottom, -12)
                .padding(.leading, 60)
            Image("owlFlyingDown1")
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.trailing, 600)
                .padding(.bottom, 150)
            Image("apple")
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.bottom, -25)
                .padding(.trailing, 100)
            VStack(alignment: .center, spacing: 16.0) {
                ZStack{
                    Image("ButtonNormalBrown")
                        .resizable()
                        .frame(width: 430, height: 130)
                    Text("OpAwesome!")
                        .font(Font.custom("Daydream", size: 30))
                        .foregroundColor(Color(.ground))
                }
                //Spacer()
                
                    Button {
                        withAnimation { self.startGame() }
                    } label: {
                        Text("START")
                            .padding()
                            //.frame(maxWidth: 195)
                            .font(Font.custom("Daydream", size: 25))
                    }
                    .background(
                        Image("wood")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 220)
                    )
                    .foregroundColor(.black)
                    .padding(.top, 50)
                HStack{
                    Button(action: {
                        showingInstructions.toggle()//true
                    }) {
                        Label("Leaderboard", systemImage: "")
                            .font(Font.custom("Daydream", size: 12))
                            .padding()
                            .foregroundColor(Color(.ground))
                    }
                    .background(
                        Image("wood2")
                            .resizable()
                            .frame(width: 160, height: 50)
                    )
                    
                    Button(action: {
                        showingInstructions.toggle()//true
                    }) {
                        Label("?", systemImage: "")
                            .font(Font.custom("Daydream", size: 19))
                            .padding()
                            .foregroundColor(Color(.ground))
                    }
                    .background(
                        Image("wood2")
                            .resizable()
                            .frame(width: 60, height: 50)
                    )
                    .sheet(isPresented: $showingInstructions) {
                        InstructionView(isPresented: $showingInstructions)
                    }
                }
                
                
               
                
            }
            .padding()
        .statusBar(hidden: true)
        }
    }
    
    /**
     * Function responsible to start the game.
     * It changes the current game state to present the view which houses the game scene.
     */
    private func startGame() {
        print("- Starting the game...")
        self.currentGameState = .playing
    }
}

#Preview {
    MainScreenView(currentGameState: .constant(GameState.mainScreen))
}
