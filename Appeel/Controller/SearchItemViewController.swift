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
import FirebaseStorage

// allows the user to search for a food item that can be entered into the virtual pantry
class SearchItemViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var searchItemLabel: UILabel!
    @IBOutlet var searchItemControl: UISearchBar!
    @IBOutlet var searchItemResults: UITableView!
    
    private var searchController: UISearchController!
    private var searchResults: [[String: Any]]! // helps populate search results
    
    var newPantryItem: PantryItem!
    
    // access keys for Edamam's Food API
    private let appId: String = ApiKeys.getEdamamFoodAppId()
    private let appKey: String = ApiKeys.getEdamamFoodAppKey()
    
    // firebase database references
    var userRef: DatabaseReference!
    var storageRef: StorageReference!
    
    // get current user id
    private let uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // formats title label
        self.searchItemLabel.text = "Search Item"
        self.searchItemLabel.font = ColorScheme.cochinItalic50
        self.searchItemLabel.textColor = ColorScheme.red
        
        searchController = UISearchController(searchResultsController: nil)
        
        self.searchResults = []
        
        self.searchItemResults.delegate = self
        self.searchItemResults.dataSource = self
        
        // initializes database references
        userRef = Database.database().reference().child("users").child(uid)
        storageRef = Storage.storage().reference().child("users").child(uid)
    }
    
    // accesses first page of search results using Edamam's Food API
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searched: String = searchItemControl.text ?? ""
        if searched != "" {
            let finalUrl = genUrl(searchParam: searched)
            self.searchResults = []
            print(finalUrl)
            AF.request(finalUrl).responseJSON { response in
                if let result = response.result.value {
                    let json = JSON(result)
                    let currPageData = json["hints"]
                    
                    var addedResult: [String: Any]
                    
                    for result in 0...currPageData.count - 1 {
                        var newResult = currPageData[result]["food"]
                        addedResult = [
                            "image": self.newPantryItem.getImgUrl(),
                            "label": newResult["label"].string ?? "",
                            "category": newResult["category"].string ?? "",
                            "brand": newResult["brand"].string ?? ""
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
    
    // populates search result cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchItemResults.dequeueReusableCell(withIdentifier: "result", for: indexPath) as! SearchItemTableViewCell
        var currRowData: [String: Any] = searchResults[indexPath.row]
        
        if currRowData.count < 4 {
            currRowData = ["": "", "": "", "": "", "": ""]
        }
        
        cell.itemLabel.text = currRowData["label"] as? String ?? ""
        cell.itemLabel.font = ColorScheme.pingFang18b
        
        cell.itemCategory.text = currRowData["category"] as? String ?? ""
        cell.itemCategory.font = ColorScheme.pingFang18
        
        cell.itemBrand.text = currRowData["brand"] as? String ?? ""
        cell.itemBrand.font = ColorScheme.pingFang18
        
        return cell
    }
    
    // generates a url for the API based on the query entered into the search bar
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
    
    // updates pantry with newly added item
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToPantry" {
            let updatedPantry: VirtualPantryViewController = segue.destination as! VirtualPantryViewController
            
            newPantryItem.setBrand(brand: searchResults![searchItemResults.indexPathForSelectedRow!.row]["brand"] as? String ?? "")
            newPantryItem.setLabel(label: searchResults![searchItemResults.indexPathForSelectedRow!.row]["label"] as? String ?? "")
            
            if newPantryItem.getImgUrl() != "" {
                let data: Data = newPantryItem.getImage().pngData() ?? Data()
                storageRef.child(newPantryItem.getImgUrl()).putData(data, metadata: nil)
            }
            
            updatedPantry.pantryItemData.append(searchResults![searchItemResults.indexPathForSelectedRow!.row])
            
            userRef.updateChildValues(["pantryItems": updatedPantry.pantryItemData])
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
