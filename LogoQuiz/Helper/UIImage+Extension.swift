//
//  UIImage+Extension.swift
//  LogoQuiz
//
//  Created by Pavan Gopal on 10/04/21.
//

import UIKit

extension UIImageView {
    func downloaded(from link: String, completion: @escaping (Bool)->Void) {
        guard let url = URL(string: link) else { completion(false); return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { completion(false); return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion(true)
            }
        }.resume()
    }
}
