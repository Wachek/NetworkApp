//
//  ViewController.swift
//  NetworkApp
//
//  Created by Вячеслав Турчак on 17.07.2022.
//

import UIKit
import Alamofire

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

        NetworkManager.shared.request(fromURL: url) { (result: Result<Dog, Error>) in
            switch result {
            case .success(let success):

//                guard let imageUrl = URL(string: success.url) else { return }

                guard let date = ImageManager.shared.fetchImage(from: success.url) else { return }
                let dogImage = UIImage(data: date)
                self.dogPictureView.image = dogImage
                self.activityIndicator.stopAnimating()
                
//                networkManager.imageRequest(fromURL: imageUrl) { (result: Result<UIImage, Error>) in
//                    switch result {
//                    case .success(let success):
//                        self.dogPictureView.image = success
//                        self.activityIndicator.stopAnimating()
//                    case .failure(let failure):
//                        print(failure)
//                    }
//                }

            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    private func fetchJoke() {
        NetworkManager.shared.fetchJoke("https://v2.jokeapi.dev/joke/Any?safe-mode") { result in
            switch result {
            case .success(let joke):
                self.jokeLabel.text = "\(joke.setup)\n\(joke.delivery)"
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
    

    
}

