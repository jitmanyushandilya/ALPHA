//
//  ViewController.swift
//  Alpha
//
//  Created by Anshuman Sharma on 3/8/20.
//  Copyright © 2020 Anshuman. All rights reserved.
//

// lay blue in i e now

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: GradientButton!
    
    private let manager = UIImagePickerController()
    private let spinner = WindowSpinner(style: .medium, color: .white)
    
    private var text: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = (segue.destination as? UINavigationController)?.topViewController as? LanguageProcessingViewController else { return }
        vc.text = text
    }
    
    @IBAction func buttonPressed(_ sender: GradientButton) {
        present(manager, animated: true)
    }
    
    private func layoutUI(){
        manager.delegate = self
        manager.sourceType = .photoLibrary
        manager.mediaTypes = ["public.movie"]
    }
    
    private func uploadVideo(url: URL) {
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let endPoint = "http://34.72.178.248:5000/video"
            
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(data, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
            }, to: endPoint).responseJSON { (response) in
                
                guard let data = response.data else { return }
                self.spinner.stopAnimating()
                
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any>
                self.text = json?["data"] as? String
                self.performSegue(withIdentifier: "LanguageSegue", sender: self)
            }
            
        } catch  {
            self.spinner.stopAnimating()
            print(error.localizedDescription)
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        manager.dismiss(animated: true)
        
        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.spinner.startAnimating(on: self.view)
            })
            uploadVideo(url: url)
            
        } else {
            print("An error occurred.")
        }
    }
    
}

extension UIColor {
    
    convenience init(hexFromString: String, alpha: CGFloat = 1.0) {
        var cString: String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt64 = 10066329
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt64(&rgbValue)
        }
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
