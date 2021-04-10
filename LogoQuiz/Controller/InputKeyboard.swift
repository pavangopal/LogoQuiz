//
//  InputKeyboard.swift
//  LogoQuiz
//
//  Created by Pavan Gopal on 10/04/21.
//

import UIKit

protocol InputKeyboardDelegate: class {
    func didPressKey(key: String)
}

final class InputKeyboard: UIStackView {
    lazy var viewModel: InputKeyboardViewModel  = InputKeyboardViewModel(delegate: self)
    weak var delegate: InputKeyboardDelegate?
    
    init(delegate: InputKeyboardDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLogo(logo: Logo) {
        self.viewModel.loadLogo(with: logo)
    }
}

extension InputKeyboard: InputKeyboardViewModelDelegate {
    func createKeyboard(with keys: String) {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
        alignment = .fill
        distribution = .fillProportionally
        axis = .horizontal
        
        for char in keys {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(self.keyboardButtonPressed(_:)), for: .touchUpInside)
            button.setTitle(String(char), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 20),
                button.widthAnchor.constraint(equalToConstant: 20)
            ])
            
            addArrangedSubview(button)
        }
    }
    
    @objc private func keyboardButtonPressed(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        self.delegate?.didPressKey(key: text)
    }
}
