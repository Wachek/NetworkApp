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
        getDogImage()
    }
    
    @IBAction func jokeButtonPressed() {
        jokeLabel.text = ""
        dogPictureView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        getJoke()
    }
    
    private func getDogImage() {
        NetworkManager.shared.fetchDog("https://random.dog/woof.json") { result in
            switch result {
            case .success(let dog):
                guard let date = ImageManager.shared.fetchImage(from: dog.url) else { return }
                let dogImage = UIImage(data: date)
                self.dogPictureView.image = dogImage
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getJoke() {
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

