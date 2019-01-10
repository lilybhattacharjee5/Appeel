//
//  AddItemViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/9/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddItemViewController: ViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var addItemLabel: UILabel!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var takePhoto: UIButton!
    @IBOutlet var addItem: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    var userRef: DatabaseReference!
    
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
        
        self.userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
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
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToSearch" {
            userRef.child("imgCounter").observeSingleEvent(of: .value, with: { (snapshot) in
                let imgNum: Int
                if snapshot.exists() {
                    imgNum = snapshot.value as? Int ?? 0
                } else {
                    imgNum = 0
                }
                let pickItem: SearchItemViewController = segue.destination as! SearchItemViewController
                if self.itemImage.image == nil {
                    pickItem.newPantryItem = PantryItem(image: self.itemImage.image ?? UIImage(), label: "", brand: "", imgUrl: "")
                } else {
                    pickItem.newPantryItem = PantryItem(image: self.itemImage.image ?? UIImage(), label: "", brand: "", imgUrl: String(imgNum) + ".png")
                    self.userRef.updateChildValues(["imgCounter": imgNum + 1])
                }
            })
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
