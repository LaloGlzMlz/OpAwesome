//
//  Score.swift
//  OpAwesome
//
//  Created by Francesca Pia Gargiulo on 18/12/23.
//

import Foundation

struct Score:  Identifiable, Codable {
    var id = UUID()
    var name: String
    var points: Int
}
