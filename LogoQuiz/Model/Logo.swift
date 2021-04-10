//
//  Logo.swift
//  LogoQuiz
//
//  Created by Pavan Gopal on 10/04/21.
//

import Foundation

struct Logo: Decodable {
    let imageUrl: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "imgUrl"
        case name = "name"
    }
}
