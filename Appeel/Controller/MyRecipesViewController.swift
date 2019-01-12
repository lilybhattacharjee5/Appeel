//
//  MyRecipesViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/11/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseDatabase
import FirebaseAuth

// allows user to view recipes they have saved or rated and some basic information about those recipes
class MyRecipesViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myRecipesLabel: UILabel!
    @IBOutlet var myRecipes: UITableView!
    
    var myRecipesLabelText: String!
    
    // helps populate the recipe table by holding data from the firebase database
    var recipeData: [String: [String: Any]]!
    private var tableData: [[String: Any]] = []
    
    // keeps track of recipe ids
    private var ids: [String] = []
    
    // firebase database reference
    private var userRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // formats title label
        myRecipesLabel.textColor = ColorScheme.red
        myRecipesLabel.font = ColorScheme.cochinItalic50
        myRecipesLabel.text = myRecipesLabelText
        
        myRecipes.delegate = self
        myRecipes.dataSource = self
        
        // using data passed through the segue, splits into recipe id and attribute data
        for (key, val) in recipeData {
            tableData.append(val)
            ids.append(key)
        }
        
        // initializes database reference
        userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myRecipes.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeData.count
    }
    
    // called to populate recipe display table cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyRecipeTableViewCell = myRecipes.dequeueReusableCell(withIdentifier: "myRecipe", for: indexPath) as! MyRecipeTableViewCell
        
        // name of recipe
        cell.label.text = tableData[indexPath.row]["label"] as? String ?? ""
        cell.label.font = ColorScheme.pingFang20
        cell.label.numberOfLines = 3
        
        // displays user's rating of the recipe, if it exists
        cell.ratingLabel.text = "YOU"
        cell.ratingLabel.font = ColorScheme.pingFang18b
        
        if tableData[indexPath.row]["rating"] != nil {
            cell.ratingValue.text = String(format: "%@", tableData[indexPath.row]["rating"] as! CVarArg)
        } else {
            cell.ratingValue.text = "?"
        }
        cell.ratingValue.font = ColorScheme.pingFang18b
        
        // obtains image from internet corresponding to recipe
        let stringUrl: String = tableData[indexPath.row]["imgUrl"] as? String ?? ""
        let url = URL(string: stringUrl)
        
        cell.recipeImage.kf.setImage(with: url)
        cell.recipeImage.translatesAutoresizingMaskIntoConstraints = false
        cell.recipeImage.layer.masksToBounds = true
        cell.recipeImage.layer.cornerRadius = 7.0
        
        return cell
    }
    
    // displays recipe directions from source website when the table cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableData[indexPath.row]["Url"] != nil {
            let url: String = tableData[indexPath.row]["Url"] as? String ?? ""
            let svc = SFSafariViewController(url: URL(string: url)!)
            present(svc, animated: true, completion: nil)
        }
    }
    
    // removes cell & recipe from database if user swipes left and presses delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableData[indexPath.row]["rating"] == nil {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                // delete item at indexPath
                self.recipeData.removeValue(forKey: self.ids[indexPath.row])
                self.ids.remove(at: indexPath.row)
                self.myRecipes.deleteRows(at: [indexPath], with: .fade)
                self.userRef.updateChildValues(["savedRecipes": self.ids])
            }
            return [delete]
        }
        return []
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
