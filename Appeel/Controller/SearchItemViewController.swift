//
//  SearchItemViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/9/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseDatabase
import FirebaseAuth

class SearchItemViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var searchItemLabel: UILabel!
    @IBOutlet var searchItemControl: UISearchBar!
    @IBOutlet var searchItemResults: UITableView!
    
    var searchController: UISearchController!
    var searchResults: [[String]]!
    
    private let appId: String = "a45d2060"
    private let appKey: String = "273ebdd46ede074bc43ae62ebee89d0f"
    
    var userRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchItemLabel.text = "Search Item"
        self.searchItemLabel.font = ColorScheme.cochinItalic50
        self.searchItemLabel.textColor = ColorScheme.red
        
        searchController = UISearchController(searchResultsController: nil)
        
        self.searchResults = [[]]
        
        self.searchItemResults.delegate = self
        self.searchItemResults.dataSource = self
        
        userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searched: String = searchItemControl.text ?? ""
        if searched != "" {
            //let finalUrl = genUrl(searchParam: searched)
            let finalUrl = "https://api.myjson.com/bins/gpavk"
            self.searchResults = []
            print(finalUrl)
            AF.request(finalUrl).responseJSON { response in
                if let result = response.result.value {
                    let json = JSON(result)
                    let currPageData = json["hints"]
                    
                    var addedResult: [String]
                    
                    for result in 0...currPageData.count - 1 {
                        var newResult = currPageData[result]["food"]
                        addedResult = [
                            newResult["label"].string ?? "",
                            newResult["category"].string ?? "",
                            newResult["brand"].string ?? ""
                        ]
                        print(addedResult)
                        self.searchResults.append(addedResult)
                    }
                    
                    self.searchItemResults.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchItemResults.dequeueReusableCell(withIdentifier: "result", for: indexPath) as! SearchItemTableViewCell
        var currRowData: [String] = searchResults[indexPath.row]
        
        if currRowData.count < 3 {
            currRowData = ["", "", ""]
        }
        
        cell.itemLabel.text = currRowData[0]
        cell.itemLabel.font = ColorScheme.pingFang18b
        
        cell.itemCategory.text = currRowData[1]
        cell.itemCategory.font = ColorScheme.pingFang18
        
        cell.itemBrand.text = currRowData[2]
        cell.itemBrand.font = ColorScheme.pingFang18
        
        return cell
    }
    
    private func genUrl(searchParam: String) -> String {
        let splitParam: [String] = searchParam.components(separatedBy: [" "])
        var finalUrl = "https://api.edamam.com/api/food-database/parser?ingr="
        var counter = 0
        for elem in splitParam {
            if counter < splitParam.count - 1 {
                finalUrl += (elem + "%20")
            } else {
                finalUrl += elem
            }
            counter += 1
        }
        finalUrl += ("&app_id=" + appId + "&app_key=" + appKey)
        return finalUrl
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPantry", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToPantry" {
            let updatedPantry: VirtualPantryViewController = segue.destination as! VirtualPantryViewController
            updatedPantry.pantryItemData.append(searchResults![searchItemResults.indexPathForSelectedRow!.row][0])
            userRef.updateChildValues(["pantryItems": updatedPantry.pantryItemData!])
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
