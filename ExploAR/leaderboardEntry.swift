//
//  leaderboardEntry.swift
//  ExploAR
//
//  Created by Nicholas Compton on 4/19/22.
//

import Foundation

struct leaderboardEntry {
    var time: Double
    var score: Int
    var accuracy: Double
    var timestamp: Int
    
    init(time: Double, score: Int, timestamp: Int, accuracy: Double){
        self.time = time
        self.score = score
        self.accuracy = accuracy
        self.timestamp = timestamp
    }
    
    func toDict() -> [String: Any] {
        return [
            "time": time,
            "score": score,
            "accuracy": accuracy,
            "timestamp": timestamp
        ]
    }
}
