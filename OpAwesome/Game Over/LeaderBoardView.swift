//
//  LeaderBoardView.swift
//  OpAwesome
//
//  Created by Francesca Pia Gargiulo on 18/12/23.
//

import SwiftUI

struct LeaderBoardView: View {
    var scores: [Score]
    
    var body: some View {
        
        let sortedScores = scores.sorted(by: {score1, score2 in
            score1.points >= score2.points})
        
        ForEach(sortedScores) { score in
            Text(score.name + " \(score.points)")
        }
    }
}

#Preview {
    LeaderBoardView(scores: [
        Score(name: "Luigi", points: 12),
        Score(name: "Mario", points: 1),
        Score(name: "Oye", points: 140)
    ])
}
