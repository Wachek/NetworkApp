//
//  Dog.swift
//  NetworkApp
//
//  Created by Вячеслав Турчак on 17.07.2022.
//

struct Dog: Decodable {
    let url: String
    
    init(dogData: [String: Any]) {
        url = dogData["url"] as? String ?? ""
    }
}
