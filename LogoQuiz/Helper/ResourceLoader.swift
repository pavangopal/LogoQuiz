//
//  ResourceLoader.swift
//  LogoQuiz
//
//  Created by Pavan Gopal on 10/04/21.
//

import Foundation

protocol ResourceLoaderProtocol {
    func loadLogoList(completion: @escaping (Result<[Logo], CustomError>) -> Void)
}

class ResouceLoader: ResourceLoaderProtocol {
    
    func loadLogoList(completion: @escaping (Result<[Logo], CustomError>) -> Void) {
        
        guard let filePath = Bundle.main.path(forResource: "logoList", ofType: "json") else {
            completion(.failure(.fileNotFound))
            return
        }
        
        let fileUrl = URL(fileURLWithPath: filePath)
        DispatchQueue.global().async(qos: .userInitiated) {
            do {
                let data = try Data(contentsOf: fileUrl)
                let logoList = try JSONDecoder().decode([Logo].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(logoList))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.customMessage(error.localizedDescription)))
                }
            }
        }
    }
}


enum CustomError: Error {
    case fileNotFound
    case customMessage(String)
    
    
    var localizedMessage: String {
        switch self {
        case .customMessage(let message):
            return message
            
        case .fileNotFound:
            return "File Not Found"
        }
    }
    
}
