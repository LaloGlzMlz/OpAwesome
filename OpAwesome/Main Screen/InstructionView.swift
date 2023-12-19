//
//  InstructionView.swift
//  OpAwesome
//
//  Created by Michel Andre Pellegrin Quiroz on 18/12/23.
//

import SwiftUI

struct InstructionView: View {
    @Binding var isPresented: Bool
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    
    var body: some View {
        VStack(){
            ZStack {
                Image("Instructions")
                
                TabView{
                    ForEach(self.gameInstructions, id: \.title){ instruction in
                        ZStack{
                            Color(.ground)
                                .clipShape(RoundedRectangle (cornerRadius: 15))
                                .frame(width: 700, height: 350)
                                .shadow(radius: 30)
                                .padding(.top, 52)
                            VStack(alignment: .center) {
                                Text(instruction.title)
                                    .font(Font.custom("Daydream", size: 25))
                                    .padding(.top, 70)
                                    .padding(.bottom, 20)
                                    .multilineTextAlignment(.center)
                                Text(instruction.description)
                                    .font(.title3)
                                    .padding(.bottom, 20)
                                    .multilineTextAlignment(.center)
                                Image(instruction.image)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                            }
                        }
                        
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                Button(action: {
                    isPresented.toggle()
                }) {
                    Label("", systemImage: "xmark.circle.fill")
                        .foregroundColor(Color(.ground))
                        .padding(.leading, 750)
                        .padding(.bottom, 310)
                }
            }
        }
    }
}

#Preview {
    InstructionView(isPresented: .constant(true))
}
