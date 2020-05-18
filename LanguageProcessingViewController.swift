//
//  LanguageProcessingViewController.swift
//  Alpha
//
//  Created by Anshuman Sharma on 3/8/20.
//  Copyright © 2020 Anshuman. All rights reserved.
//

import UIKit

class LanguageProcessingViewController: UIViewController {
    
    @IBOutlet weak var translateButton: GradientButton!
    @IBOutlet weak var tryAgainButton: GradientButton!
    @IBOutlet weak var outputOfViewTextView: UITextView!
    
    private let translator = SwiftGoogleTranslate.shared
    private let APIKey = "AIzaSyCH8ZDDtZVECrXUClGI9cX8W59tUmXViuI"
    
    private let spinner = WindowSpinner(style: .medium, color: .white)
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    private func layoutUI(){
        outputOfViewTextView.text = text
        tryAgainButton.colors = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]
        translateButton.colors = [#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]
        
        outputOfViewTextView.layer.cornerRadius = 5
        outputOfViewTextView.layer.borderColor = UIColor.lightGray.cgColor
        outputOfViewTextView.layer.borderWidth = 0.5
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        isModalInPresentation = true
    }
    
    @IBAction func retryButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func translateButtonPressed(_ sender: GradientButton) {
        let controller = UIAlertController(title: "Choose Language", message: nil, preferredStyle: .alert)
        
        let frenchAction = UIAlertAction(title: "French", style: .default, handler: { action in
            self.mapText("fr")
        })
        
        let germanAction = UIAlertAction(title: "German", style: .default, handler: { action in
            self.mapText("de")
        })
        
        let hindiAction = UIAlertAction(title: "Hindi", style: .default, handler: { action in
            self.mapText("hi")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            controller.dismiss(animated: true)
        })
        
        controller.addAction(frenchAction)
        controller.addAction(germanAction)
        controller.addAction(hindiAction)
        controller.addAction(cancel)
        present(controller, animated: true)
    }
    
    private func mapText(_ type: String){
        spinner.startAnimating(on: view)
        
        translator.start(with: APIKey)
        guard let text = text else { return }
        
        translator.translate(text, type, "en") { text, error in
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            
            if let text = text {
                DispatchQueue.main.async {
                    self.outputOfViewTextView.text = text
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
}
