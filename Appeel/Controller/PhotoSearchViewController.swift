//
//  PhotoSearchViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/10/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

// allows the user to select a photo of food from their library or take a photo
// to split into component ingredient guesses
class PhotoSearchViewController: ViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var photoSearchLabel: UILabel!
    @IBOutlet var mealPhoto: UIImageView!
    @IBOutlet var takePhoto: UIButton!
    @IBOutlet var getPhoto: UIButton!
    @IBOutlet var nextToAI: UIButton!
    
    private var imagePicker: UIImagePickerController = UIImagePickerController() // for image selection
    
    private let padding: CGFloat = 7.0
    private let borderRadius: CGFloat = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // format go back button
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        // format next to Clarifai concept selection button
        self.nextToAI.setTitle(">", for: .normal)
        self.nextToAI.setTitleColor(ColorScheme.black, for: .normal)
        self.nextToAI.layer.cornerRadius = borderRadius
        self.nextToAI.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.nextToAI.titleLabel!.font = ColorScheme.pingFang24
        self.nextToAI.backgroundColor = ColorScheme.blue
        
        // format title label
        self.photoSearchLabel.text = "Photo Search"
        self.photoSearchLabel.textColor = ColorScheme.red
        self.photoSearchLabel.font = ColorScheme.cochinItalic60
        
        // format take photo button
        self.takePhoto.setTitle("Take Photo", for: .normal)
        self.takePhoto.setTitleColor(ColorScheme.black, for: .normal)
        self.takePhoto.layer.cornerRadius = borderRadius
        self.takePhoto.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.takePhoto.titleLabel!.font = ColorScheme.pingFang18
        self.takePhoto.backgroundColor = ColorScheme.yellow
        
        // format photo library button
        self.getPhoto.setTitle("Photo Library", for: .normal)
        self.getPhoto.setTitleColor(ColorScheme.black, for: .normal)
        self.getPhoto.layer.cornerRadius = borderRadius
        self.getPhoto.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.getPhoto.titleLabel!.font = ColorScheme.pingFang18
        self.getPhoto.backgroundColor = ColorScheme.green
    }
    
    // goes to photo library on phone when button is pressed
    @IBAction func goToLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // goes to phone camera when button is pressed
    @IBAction func goToCamera(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    // sets image of meal displayed on screen as the one picked from either camera / library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            mealPhoto.image = image
        }
    }
    
    // segues to Clarifai API when the > button is pressed & an image has been selected
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
