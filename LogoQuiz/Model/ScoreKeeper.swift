//
//  ScoreKeeper.swift
//  LogoQuiz
//
//  Created by Pavan Gopal on 10/04/21.
//

import Foundation

final class ScoreKeeper {
    private var timer = Timer()
    private var currentTime = 0
    private var currentScoreRange: ScoreRange = .master
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(update)), userInfo: nil, repeats: true)
    }
    
    @objc private func update() {
        currentTime += 1
        
        switch currentTime {
        case 0...5:
            self.currentScoreRange = .master
        case 5...10:
            self.currentScoreRange = .advance
        case 10...15:
            self.currentScoreRange = .intermittent
        default:
            self.currentScoreRange = .beginner
        }
    }
    
    func getScore() -> Int {
        defer { resetTimer() }
        
        return currentScoreRange.score
    }
    
    private func resetTimer() {
        currentScoreRange = .master
        currentTime = 0
        timer.invalidate()
    }
    
    private enum ScoreRange {
        case master
        case advance
        case intermittent
        case beginner
        
        var score: Int {
            switch self {
            case .master:
                return 100
            case .advance:
                return 80
            case .intermittent:
                return 30
            case .beginner:
                return 10
                
            }
        }
        
    }
}

