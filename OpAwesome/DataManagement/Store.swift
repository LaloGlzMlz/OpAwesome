//
//  Store.swift
//  OpAwesome
//
//  Created by Francesca Pia Gargiulo on 18/12/23.
//

import Foundation

class Store: ObservableObject {
    @Published var scores: [Score] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("game.data")
    }
    
    func load() async throws {
        let task = Task<[Score], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let loadedScores = try JSONDecoder().decode([Score].self, from: data)
            return loadedScores
        }
        let scores = try await task.value
        self.scores = scores
    }
    
    @MainActor
    func save(scores: [Score]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(scores)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    
}
