//
//  NetworkManager.swift
//  NetworkApp
//
//  Created by Вячеслав Турчак on 19.07.2022.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchJoke(_ url: String, completion: @escaping(Result<Joke, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let jokeData = value as? [String: Any] else { return }
                    let joke = Joke(jokeData: jokeData)
                    completion(.success(joke))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchDog(_ url: String, completion: @escaping(Result<Dog, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let dogData = value as? [String: Any] else { return }
                    let dog = Dog(dogData: dogData)
                    completion(.success(dog))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}

class ImageManager {
    
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchImage(from url: String?) -> Data? {
        guard let stringURL = url else { return nil }
        guard let imageURL = URL(string: stringURL) else { return nil }
        return try? Data(contentsOf: imageURL)
    }
}
