//
//  CurrentStatusViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CurrentStatusViewController: ViewController {

    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var accountNameLabel: UILabel!
    @IBOutlet var tabDisplay: UITabBarItem!
    @IBOutlet var recipesLabel: UILabel!
    @IBOutlet var analyticsLabel: UILabel!
    
    @IBOutlet var logout: UIButton!
    @IBOutlet var viewSaved: UIButton!
    @IBOutlet var viewTried: UIButton!
    
    @IBOutlet var analyticsList: UITableView!
    
    var ref: DatabaseReference!
    
    var nextControllerData: [String: [String: Any]]!
    var nextControllerTitle: String!

    var currentUser: UserProfile!
    var email: String!
    var firstName: String!
    var lastName: String!
    var imgCounter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.welcomeLabel.text = "Welcome,"
        self.welcomeLabel.textColor = ColorScheme.red
        self.welcomeLabel.font = ColorScheme.pingFang50
        
        self.accountNameLabel.text = ""
        self.accountNameLabel.textColor = ColorScheme.red
        self.accountNameLabel.font = ColorScheme.cochinItalic50
        self.accountNameLabel.textAlignment = .right
        
        self.recipesLabel.text = "My Recipes"
        self.recipesLabel.font = ColorScheme.pingFang24
        
        self.analyticsLabel.text = "My Analytics"
        self.analyticsLabel.font = ColorScheme.pingFang24
        
        let padding: CGFloat = 7.0
        let borderRadius: CGFloat = 5.0
        
        self.logout.setTitle("Log Out", for: .normal)
        self.logout.setTitleColor(ColorScheme.black, for: .normal)
        self.logout.layer.cornerRadius = borderRadius
        self.logout.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.logout.titleLabel!.font = ColorScheme.pingFang18
        self.logout.backgroundColor = ColorScheme.pink
        
        viewSaved.titleLabel!.font = ColorScheme.pingFang18b
        viewSaved.setTitleColor(ColorScheme.black, for: .normal)
        viewSaved.backgroundColor = ColorScheme.green
        viewSaved.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        viewSaved.layer.cornerRadius = padding
        
        viewTried.titleLabel!.font = ColorScheme.pingFang18b
        viewTried.setTitleColor(ColorScheme.black, for: .normal)
        viewTried.backgroundColor = ColorScheme.yellow
        viewTried.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        viewTried.layer.cornerRadius = padding
        
        viewSaved.setTitle("Saved", for: .normal)
        viewTried.setTitle("Tried", for: .normal)
        
        ref = Database.database().reference()
        let rawUser: User = Auth.auth().currentUser!
        ref.child("users").child(rawUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let userInfo = snapshot.value as? NSDictionary
            self.email = userInfo?["email"] as? String ?? ""
            self.firstName = userInfo?["firstName"] as? String ?? ""
            self.lastName = userInfo?["lastName"] as? String ?? ""
            self.imgCounter = userInfo?["imgCounter"] as? Int ?? 0
            self.currentUser = UserProfile(email: self.email, firstName: self.firstName, lastName: self.lastName, imgCounter: self.imgCounter)
            self.accountNameLabel.text = self.firstName + "."
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewRecipes" {
            let myRecipes: MyRecipesViewController = segue.destination as! MyRecipesViewController
            myRecipes.myRecipesLabelText = self.nextControllerTitle
            myRecipes.recipeData = self.nextControllerData
        }
    }
    
    func getRecipes(type: String, title: String, _ sender: Any) {
        ref.child("users").child(Auth.auth().currentUser!.uid).child(type).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                var counter = 0
                var tableData: [String: [String: Any]] = [:]
                let allRecipeIds: [String]
                if type == "ratedRecipes" {
                    allRecipeIds = Array((snapshot.value as! [String: Int]).keys)
                } else {
                    allRecipeIds = (snapshot.value as! [String])
                }
                for recipeId in allRecipeIds {
                    self.getRecipe(recipeId: recipeId) { success in
                        tableData[recipeId] = success
                        if counter == allRecipeIds.count - 1 {
                            self.nextControllerData = tableData
                            self.nextControllerTitle = title
                            self.performSegue(withIdentifier: "viewRecipes", sender: sender)
                        }
                        counter += 1
                    }
                }
            }
        })
    }
    
    @IBAction func getRatedRecipes(_ sender: Any) {
        getRecipes(type: "ratedRecipes", title: "Rated", sender)
    }

    @IBAction func getSavedRecipes(_ sender: Any) {
        getRecipes(type: "savedRecipes", title: "Saved", sender)
    }
    
    func getRecipe(recipeId: String, completionHandler: @escaping ([String: Any]) -> ()) {
        let recipeRef: DatabaseReference = self.ref.child("recipes")
        recipeRef.child(recipeId).observeSingleEvent(of: .value, with: { (recipeSnapshot) in
            completionHandler(recipeSnapshot.value as? [String: Any] ?? [:])
        })
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
