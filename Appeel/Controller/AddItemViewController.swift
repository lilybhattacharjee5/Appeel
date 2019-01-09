//
//  AddItemViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/9/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class AddItemViewController: ViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var addItemLabel: UILabel!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var takePhoto: UIButton!
    @IBOutlet var addItem: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let padding: CGFloat = 7.0
        let borderRadius: CGFloat = 5.0
        
        self.addItemLabel.text = "Add Item"
        self.addItemLabel.textColor = ColorScheme.red
        self.addItemLabel.font = ColorScheme.cochinItalic60
        
        self.addItem.setTitle(">", for: .normal)
        self.addItem.setTitleColor(ColorScheme.black, for: .normal)
        self.addItem.layer.cornerRadius = borderRadius
        self.addItem.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.addItem.titleLabel!.font = ColorScheme.pingFang24
        self.addItem.backgroundColor = ColorScheme.blue
        
        self.takePhoto.setTitle("Take Photo", for: .normal)
        self.takePhoto.setTitleColor(ColorScheme.black, for: .normal)
        self.takePhoto.layer.cornerRadius = borderRadius
        self.takePhoto.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.takePhoto.titleLabel!.font = ColorScheme.pingFang18
        self.takePhoto.backgroundColor = ColorScheme.yellow
        
        self.itemImage.layer.cornerRadius = padding
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func goToCamera(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        itemImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        print("hey")
        imagePicker.dismiss(animated: true, completion: nil)
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
