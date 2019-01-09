//
//  VirtualPantryViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class VirtualPantryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var virtualPantryLabel: UILabel!
    @IBOutlet var tabDisplay: UITabBarItem!
    @IBOutlet var virtualPantryItem: UITabBarItem!
    @IBOutlet var addItem: UIButton!
    @IBOutlet var pantryItems: UITableView!
    
    var pantryItemData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.virtualPantryLabel.text = "Virtual Pantry"
        self.virtualPantryLabel.textColor = ColorScheme.red
        self.virtualPantryLabel.font = ColorScheme.cochinItalic60
        
        let padding: CGFloat = 7.0
        let borderRadius: CGFloat = 5.0
        
        self.addItem.setTitle("+", for: .normal)
        self.addItem.setTitleColor(ColorScheme.black, for: .normal)
        self.addItem.layer.cornerRadius = borderRadius
        self.addItem.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.addItem.titleLabel!.font = ColorScheme.pingFang24
        self.addItem.backgroundColor = ColorScheme.green
        
        pantryItemData = []
        
        self.pantryItems.delegate = self
        self.pantryItems.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pantryItems.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pantryItemData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pantryItems.dequeueReusableCell(withIdentifier: "pantry") as! PantryItemTableViewCell
        cell.itemName.text = pantryItemData[indexPath.row]
        return cell
    }
    
    @IBAction func unwindToVirtualPantry(segue: UIStoryboardSegue) {
        
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
