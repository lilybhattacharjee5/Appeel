//
//  MyRecipesViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/11/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import SafariServices

class MyRecipesViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myRecipesLabel: UILabel!
    @IBOutlet var myRecipes: UITableView!
    var myRecipesLabelText: String!
    var recipeData: [String: [String: Any]]!
    var tableData: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myRecipesLabel.textColor = ColorScheme.red
        myRecipesLabel.font = ColorScheme.cochinItalic50
        myRecipesLabel.text = myRecipesLabelText
        
        myRecipes.delegate = self
        myRecipes.dataSource = self
        
        for (key, val) in recipeData {
            tableData.append(val)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyRecipeTableViewCell = myRecipes.dequeueReusableCell(withIdentifier: "myRecipe", for: indexPath) as! MyRecipeTableViewCell
        
        cell.label.text = tableData[indexPath.row]["label"] as? String ?? ""
        cell.label.font = ColorScheme.pingFang20
        cell.label.numberOfLines = 3
        
        let stringUrl: String = tableData[indexPath.row]["imgUrl"] as? String ?? ""
        let url = URL(string: stringUrl)
        
        cell.recipeImage.kf.setImage(with: url)
        cell.recipeImage.translatesAutoresizingMaskIntoConstraints = false
        cell.recipeImage.layer.masksToBounds = true
        cell.recipeImage.layer.cornerRadius = 7.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url: String = tableData[indexPath.row]["Url"] as? String ?? ""
        let svc = SFSafariViewController(url: URL(string: url)!)
        present(svc, animated: true, completion: nil)
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
