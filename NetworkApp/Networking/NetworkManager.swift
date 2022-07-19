//
//  NetworkManager.swift
//  NetworkApp
//
//  Created by Вячеслав Турчак on 19.07.2022.
//

import Foundation
import UIKit

class NetworkManager {
    
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
    
    func imageRequest<T> (fromURL url: URL, completion: @escaping (Result<T, Error>) -> Void) {
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
            
            guard let image = UIImage(data: data) else { return }
            completionOnMain(.success(image as! T))
    
        }.resume()
    }
    
}
