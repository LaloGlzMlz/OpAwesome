//
//  LeaderBoardView.swift
//  OpAwesome
//
//  Created by Francesca Pia Gargiulo on 18/12/23.
//

import SwiftUI

struct LeaderBoardView: View {
    var scores: [Score]
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack{
            Image("FondoInicio")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                ZStack{
                    Image("wood2")
                        .resizable()
                        .frame(width: 430, height: 70)
                    Text("Leaderboard")
                        .font(Font.custom("Daydream", size: 30))
                        .foregroundColor(Color(.ground))
                }
                .padding(.top, 35)
                ScrollView{
                    VStack{
                        let sortedScores = scores.sorted(by: {score1, score2 in
                            score1.points >= score2.points})
                        
                        ForEach(sortedScores) { score in
                            Text(score.name + " \(score.points)")
                                .font(.title2)
                                .bold()
                        }
                    }
                    
                }
                .padding(.bottom, 40)
                //Spacer()
            }
            Button(action: {
                isPresented.toggle()
            }) {
                Image("close_button")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color(.ground))
                    .padding(.leading, 750)
                    .padding(.bottom, 310)
            }
            
        }
        
        
    }
}

#Preview {
    LeaderBoardView(scores: [
        Score(name: "Luigi", points: 12),
        Score(name: "Mario", points: 1),
        Score(name: "Oye", points: 140)
    ], isPresented: .constant(true))
}
