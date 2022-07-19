//
//  ViewController.swift
//  NetworkApp
//
//  Created by Вячеслав Турчак on 17.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var dogPictureView: UIImageView!
    @IBOutlet var jokeLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
    }

    @IBAction func pictureButtonPressed() {
        dogPictureView.image = nil
        dogPictureView.isHidden = false
        jokeLabel.text = ""
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchImage()
    }
    
    @IBAction func jokeButtonPressed() {
        jokeLabel.text = ""
        dogPictureView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchJoke()
    }
    
    private func fetchImage() {
        guard let url = URL(string: "https://random.dog/woof.json") else { return }
        
        let networkManager = NetworkManager()
        
        networkManager.request(fromURL: url) { (result: Result<Dog, Error>) in
            switch result {
            case .success(let success):
                
                guard let imageUrl = URL(string: success.url) else { return }
                
                networkManager.imageRequest(fromURL: imageUrl) { (result: Result<UIImage, Error>) in
                    switch result {
                    case .success(let success):
                        self.dogPictureView.image = success
                        self.activityIndicator.stopAnimating()
                    case .failure(let failure):
                        print(failure)
                    }
                }
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    private func fetchJoke() {
        guard let url = URL(string: "https://v2.jokeapi.dev/joke/Any?safe-mode") else { return }
        
        let networkManager = NetworkManager()
        
        networkManager.request(fromURL: url) { (result: Result<Joke, Error>) in
            switch result {
            case .success(let success):
                self.jokeLabel.text = "\(success.setup)\n\(success.delivery)"
                self.activityIndicator.stopAnimating()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}

