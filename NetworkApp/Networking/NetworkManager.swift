//
//  NetworkManager.swift
//  NetworkApp
//
//  Created by Вячеслав Турчак on 19.07.2022.
//

import Foundation
//import UIKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchJoke(_ url: String, completion: @escaping(Result<Joke, Error>) -> Void) {
        AF.request("https://v2.jokeapi.dev/joke/Any?safe-mode")
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
    
    func request<T: Decodable>(fromURL url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        
        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(value))
            } catch let error {
                print(error.localizedDescription)
                completionOnMain(.failure(error))
            }
            
        }.resume()
    }
    
//    func imageRequest<T> (fromURL url: URL, completion: @escaping (Result<T, Error>) -> Void) {
//        let completionOnMain: (Result<T, Error>) -> Void = { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//
//            guard let image = UIImage(data: data) else { return }
//            completionOnMain(.success(image as! T))
//
//        }.resume()
//    }
    
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
