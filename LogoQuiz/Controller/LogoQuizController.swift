//
//  LogoQuizController.swift
//  LogoQuiz
//
//  Created by Pavan Gopal on 10/04/21.
//

import UIKit

final class LogoQuizController: UIViewController {
    
    private lazy var viewModel = LogoQuizViewModel(delegate: self)
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var skipLevelItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Skip", style: .done, target: self, action: #selector(self.skipLevelButtonPressed))
        return barButton
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.isEnabled = false
        return textField
    }()
    
    lazy var keyboard: InputKeyboard = {
        let keyboard = InputKeyboard(delegate: self)
        keyboard.translatesAutoresizingMaskIntoConstraints = false
        return keyboard
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.fetchLogos()
        
        setupNotifications()
    }
    
    private func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func appMovedToBackground() {
        viewModel.appMovedToBackground()
    }
    
    @objc private func appMovedToForeground() {
        viewModel.appMovedToForeground()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(keyboard)
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyboard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            keyboard.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
        
        navigationItem.rightBarButtonItem = skipLevelItem
        
    }
    
    
    @objc private func skipLevelButtonPressed() {
        viewModel.skipLevelButtonTapped()
    }
    
}

extension LogoQuizController: LogoQuizViewModelDelegate {
    func showCorrect(score: Int) {
        //TODO: Show the score to the user
        print("Your Score is: \(score)")
    }
    
    func displayLogo(logo: Logo) {
        self.logoImageView.downloaded(from: logo.imageUrl) { [weak self] (isLoaded) in
            self?.viewModel.logoLoaded()
        }
        keyboard.loadLogo(logo: logo)
    }
    
    
}

extension LogoQuizController: InputKeyboardDelegate {
    func didPressKey(key: String) {
        self.viewModel.logoNameKeyPressed(key: key)
    }
    
    
}
