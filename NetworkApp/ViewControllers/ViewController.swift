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
        dogPictureView.isHidden = false
        jokeLabel.text = ""
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchImage()
    }
    
    @IBAction func jokeButtonPressed() {
        dogPictureView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchJoke()
    }
    
    private func fetchImage() {
        guard let url = URL(string: "https://random.dog/c22c077e-a009-486f-834c-a19edcc36a17.jpg") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.dogPictureView.image = image
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }
    
    private func fetchJoke() {
        guard let url = URL(string: "https://v2.jokeapi.dev/joke/Any?safe-mode") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }

            do {
                let joke = try JSONDecoder().decode(Joke.self, from: data)
                DispatchQueue.main.async {
                    self.jokeLabel.text = "\(joke.setup)\n\(joke.delivery)"
                    self.activityIndicator.stopAnimating()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
            
        }.resume()
    }
    
}

