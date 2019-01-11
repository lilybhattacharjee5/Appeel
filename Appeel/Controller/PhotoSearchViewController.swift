//
//  PhotoSearchViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/10/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class PhotoSearchViewController: ViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var photoSearchLabel: UILabel!
    @IBOutlet var mealPhoto: UIImageView!
    @IBOutlet var takePhoto: UIButton!
    @IBOutlet var getPhoto: UIButton!
    @IBOutlet var nextToAI: UIButton!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var conceptMatches: [[String: Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let padding: CGFloat = 7.0
        let borderRadius: CGFloat = 5.0
        
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        self.nextToAI.setTitle(">", for: .normal)
        self.nextToAI.setTitleColor(ColorScheme.black, for: .normal)
        self.nextToAI.layer.cornerRadius = borderRadius
        self.nextToAI.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.nextToAI.titleLabel!.font = ColorScheme.pingFang24
        self.nextToAI.backgroundColor = ColorScheme.blue
        
        self.photoSearchLabel.text = "Photo Search"
        self.photoSearchLabel.textColor = ColorScheme.red
        self.photoSearchLabel.font = ColorScheme.cochinItalic60
        
        self.takePhoto.setTitle("Take Photo", for: .normal)
        self.takePhoto.setTitleColor(ColorScheme.black, for: .normal)
        self.takePhoto.layer.cornerRadius = borderRadius
        self.takePhoto.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.takePhoto.titleLabel!.font = ColorScheme.pingFang18
        self.takePhoto.backgroundColor = ColorScheme.yellow
        
        self.getPhoto.setTitle("Photo Library", for: .normal)
        self.getPhoto.setTitleColor(ColorScheme.black, for: .normal)
        self.getPhoto.layer.cornerRadius = borderRadius
        self.getPhoto.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.getPhoto.titleLabel!.font = ColorScheme.pingFang18
        self.getPhoto.backgroundColor = ColorScheme.green
    }
    
    @IBAction func goToLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func goToCamera(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            mealPhoto.image = image
        }
    }
    
    @IBAction func goToResults(_ sender: Any) {
        if self.mealPhoto.image != nil {
            self.performSegue(withIdentifier: "photoResults", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "photoResults" {
            let resultsPage: IngredientChoicesViewController = segue.destination as! IngredientChoicesViewController
            resultsPage.imageData = self.mealPhoto.image
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
