//
//  LogoQuizViewModel.swift
//  LogoQuiz
//
//  Created by Pavan Gopal on 10/04/21.
//

import Foundation

protocol LogoQuizViewModelDelegate: class {
    func displayLogo(logo: Logo)
    func showCorrect(score: Int)
}

final class LogoQuizViewModel {
    private let resourceLoader: ResourceLoaderProtocol
    private weak var delegate: LogoQuizViewModelDelegate?
    private var currentLevel: Int = 0
    private var logoList: [Logo] = []
    private let scoreKeeper: ScoreKeeper = ScoreKeeper()
    
    private var currentText: String = "" {
        didSet {
            if validateLogoName() {
                delegate?.showCorrect(score: scoreKeeper.getScore())
            }
        }
    }
    
    init(resourceLoader: ResourceLoaderProtocol = ResouceLoader(), delegate: LogoQuizViewModelDelegate ) {
        self.resourceLoader = resourceLoader
        self.delegate = delegate
    }
    
    func fetchLogos() {
        resourceLoader.loadLogoList { (result) in
            switch result {
            case .success(let logoList):
                self.logoList = logoList
                if let firstLogo = self.logoList.first {
                    self.delegate?.displayLogo(logo: firstLogo)
                }
                
            case .failure(let error):
                print(error.localizedMessage)
            }
        }
    }
    
    func skipLevelButtonTapped() {
        currentLevel += 1
        guard let nextLevelLogo = loadNextLevel() else {
            //TODO: Show this to user
            print("Completed All levels")
            return
        }
        self.delegate?.displayLogo(logo: nextLevelLogo)
    }
    
    private func loadNextLevel() -> Logo? {
        guard currentLevel < logoList.count else { return nil }
        
        return logoList[currentLevel]
    }
    
    private func loadCurrentLevel() -> Logo {
        return logoList[currentLevel]
    }
    
    func logoNameKeyPressed(key: String) {
        self.currentText = currentText + key
    }
    
    func validateLogoName() -> Bool {
        let logo = self.loadCurrentLevel()
        return logo.name == self.currentText
    }
    
    func logoLoaded() {
        self.scoreKeeper.startTimer()
    }
    
}
