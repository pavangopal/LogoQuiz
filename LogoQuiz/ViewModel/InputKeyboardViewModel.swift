//
//  InputKeyboardViewModel.swift
//  LogoQuiz
//
//  Created by Pavan Gopal on 10/04/21.
//

import Foundation

protocol InputKeyboardViewModelDelegate: class {
    func createKeyboard(with keys: String)
}

final class InputKeyboardViewModel {
    private let maxNameCount = 12
    weak var delegate: InputKeyboardViewModelDelegate?
    
    init(delegate: InputKeyboardViewModelDelegate) {
        self.delegate = delegate
    }
    
    func loadLogo(with logo: Logo) {
        createKeys(logo: logo)
    }
    
    private func createKeys(logo: Logo) {
        let logoCharCount = logo.name.count
        let extraCharNeeded = maxNameCount - logoCharCount
        let randomStr = randomString(of: extraCharNeeded)
        
        let shuffled = (randomStr+logo.name).shuffled()
        
        self.delegate?.createKeyboard(with: String(shuffled))
    }
    
    func randomString(of length: Int, letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ") -> String {
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
}
