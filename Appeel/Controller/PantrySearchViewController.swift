//
//  PantrySearchViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/8/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

class PantrySearchViewController: ViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var nextGeneral: UIButton!
    @IBOutlet var pantrySearchLabel: UILabel!
    @IBOutlet var pantrySearchItems: UITableView!
    
    var query: String!
    
    var userRef: DatabaseReference!
    
    var selectedCells: [PantrySearchTableViewCell] = []
    
    var pantryItemData: [[String: Any]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        pantrySearchLabel.text = "Pantry Search"
        pantrySearchLabel.textColor = ColorScheme.red
        pantrySearchLabel.font = ColorScheme.cochinItalic50
        
        let padding: CGFloat = 7.0
        let borderRadius: CGFloat = 5.0
        
        self.nextGeneral.setTitle(">", for: .normal)
        self.nextGeneral.setTitleColor(ColorScheme.black, for: .normal)
        self.nextGeneral.layer.cornerRadius = borderRadius
        self.nextGeneral.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.nextGeneral.titleLabel!.font = ColorScheme.pingFang24
        self.nextGeneral.backgroundColor = ColorScheme.blue
        
        query = ""
        
        pantrySearchItems.delegate = self
        pantrySearchItems.dataSource = self
        pantrySearchItems.allowsMultipleSelection = true
        
        userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        populatePantryItems()
    }
    
    private func populatePantryItems() {
        getPantryData() { response in
            self.pantryItemData = response
            self.pantrySearchItems.reloadData()
        }
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pantryToGeneral" {
            let pantryToGen: GeneralSearchViewController = segue.destination as! GeneralSearchViewController
            pantryToGen.query = self.query
        }
    }
    
    @IBAction func goToGeneral(_ sender: Any) {
        self.query = composeQuery()
        print(query)
        if self.query != "" {
            performSegue(withIdentifier: "pantryToGeneral", sender: sender)
        }
    }
    
    private func composeQuery() -> String {
        var returnedQuery: String = ""
        var counter = 0
        for selectedCell in selectedCells {
            let currVal = selectedCell.label.text ?? ""
            if counter < selectedCells.count - 1 {
                if currVal != "" {
                    returnedQuery += (currVal + " ")
                }
            } else {
                returnedQuery += currVal
            }
            counter += 1
        }
        return returnedQuery
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pantrySearchItems.dequeueReusableCell(withIdentifier: "pantry") as! PantrySearchTableViewCell
        cell.label.text = pantryItemData[indexPath.row]["label"] as? String ?? ""
        cell.label.font = ColorScheme.pingFang18b
        cell.brand.text = pantryItemData[indexPath.row]["brand"] as? String ?? ""
        cell.brand.font = ColorScheme.pingFang18
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = pantrySearchItems.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = ColorScheme.pink
        selectedCells.append(selectedCell as! PantrySearchTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellToDeSelect:UITableViewCell = pantrySearchItems.cellForRow(at: indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.clear
        if let index = selectedCells.index(of: cellToDeSelect as! PantrySearchTableViewCell) {
            selectedCells.remove(at: index)
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
