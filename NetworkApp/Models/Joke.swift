//
//  Joke.swift
//  NetworkApp
//
//  Created by Вячеслав Турчак on 17.07.2022.
//

struct Joke: Decodable {
    let setup: String
    let delivery: String
    
    init(jokeData: [String: Any]) {
        setup = jokeData["setup"] as? String ?? ""
        delivery = jokeData["delivery"] as? String ?? ""
    }
}
