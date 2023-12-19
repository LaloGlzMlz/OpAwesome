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
            Image("StartView")
                .resizable()
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 16.0) {
                Button {
                    withAnimation { self.startGame() }
                } label: {
                    Text("START")
                        .padding()
                        .frame(maxWidth: 195)
                        .font(Font.custom("Daydream", size: 25))
                }
                .foregroundColor(.black)
                .background(.red)
                .cornerRadius(10.0)
                .padding()
                
                Button(action: {
                    showingInstructions.toggle()//true
                }) {
                    Label("?", systemImage: "")
                        .font(Font.custom("Daydream", size: 25))
                        .padding(.bottom, 5)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showingInstructions) {
                    InstructionView(isPresented: $showingInstructions)
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
