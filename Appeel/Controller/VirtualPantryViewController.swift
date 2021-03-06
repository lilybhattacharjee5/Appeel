//
//  VirtualPantryViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseUI

class VirtualPantryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var virtualPantryLabel: UILabel!
    @IBOutlet var tabDisplay: UITabBarItem!
    @IBOutlet var virtualPantryItem: UITabBarItem!
    @IBOutlet var addItem: UIButton!
    @IBOutlet var pantryItems: UITableView!
    
    // keeps track of displayed pantry item data (for tableview)
    var pantryItemData: [[String: Any]]!
    private var imageData: [UIImage]!
    
    // firebase database references
    private var userRef: DatabaseReference!
    private var storageRef: StorageReference!
    
    private let padding: CGFloat = 7.0
    private let borderRadius: CGFloat = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // format title label
        self.virtualPantryLabel.text = "Virtual Pantry"
        self.virtualPantryLabel.textColor = ColorScheme.red
        self.virtualPantryLabel.font = ColorScheme.cochinItalic60
        
        // format add item button
        self.addItem.setTitle("+", for: .normal)
        self.addItem.setTitleColor(ColorScheme.black, for: .normal)
        self.addItem.layer.cornerRadius = borderRadius
        self.addItem.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.addItem.titleLabel!.font = ColorScheme.pingFang24
        self.addItem.backgroundColor = ColorScheme.green
        
        // initialize firebase database references
        userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        storageRef = Storage.storage().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        self.pantryItems.delegate = self
        self.pantryItems.dataSource = self
        
        // populate pantry with items from database access (user branch)
        populatePantry()
    }
    
    private func populatePantry() {
        getPantryData() { response in
            self.pantryItemData = response
            self.pantryItems.reloadData()
        }
    }
    
    // get all pantry item info stored in database (+ attributes like brand)
    private func getPantryData(completionHandler: @escaping ([[String: Any]]) -> Void) {
        userRef.child("pantryItems").observeSingleEvent(of: .value, with: { (snapshot) in
            var allPantryData: [[String: Any]]
            if snapshot.exists() {
                allPantryData = snapshot.value as? [[String: Any]] ?? []
            } else {
                allPantryData = []
            }
            completionHandler(allPantryData)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pantryItems.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pantryItemData == nil {
            return 0
        }
        return pantryItemData.count
    }
    
    // populates each pantry item cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pantryItems.dequeueReusableCell(withIdentifier: "pantry") as! PantryItemTableViewCell
        
        // formats item name
        cell.itemName.text = pantryItemData[indexPath.row]["label"] as? String ?? ""
        cell.itemName.font = ColorScheme.pingFang18b
        
        // formats item brand
        cell.itemBrand.text = pantryItemData[indexPath.row]["brand"] as? String ?? ""
        cell.itemBrand.font = ColorScheme.pingFang18
        
        // accesses image data from firebase storage
        let currImgUrl = pantryItemData[indexPath.row]["image"] as? String ?? ""
        if currImgUrl != "" {
            let imageRef = storageRef.child(currImgUrl)
            print(imageRef)
            cell.itemImage.sd_setImage(with: imageRef, placeholderImage: UIImage())
        }
        
        return cell
    }
    
    // if a cell is deleted, the item is removed from firebase pantry items corresponding to current user
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.pantryItemData.remove(at: indexPath.row)
            self.pantryItems.deleteRows(at: [indexPath], with: .fade)
            self.userRef.updateChildValues(["pantryItems": self.pantryItemData])
        }
        
        return [delete]
    }
    
    @IBAction func unwindToVirtualPantry(segue: UIStoryboardSegue) {
        pantryItems.reloadData()
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
