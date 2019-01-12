//
//  RecipeZoomViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/7/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos
import FirebaseDatabase
import FirebaseAuth
import SafariServices

// displays the selected recipe with all of its attributes ex. preparation time, num of servings, etc.
class RecipeZoomViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var rating: CosmosView!
    @IBOutlet var goBack: UIButton!
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var recipeImg: UIImageView!
    @IBOutlet var save: UIButton!
    @IBOutlet var tried: UIButton!
    @IBOutlet var recipeInfoTable: UITableView!
    @IBOutlet var numRatings: UILabel!
    
    var currRecipe: Recipe! // current recipe being displayed
    var displayedAttributes: [[String]]! // holds attributes of current recipe to populate tableview
    
    // firebase database reference
    private var ref: DatabaseReference!
    private var userRef: DatabaseReference!
    private var recipeRef: DatabaseReference!
    
    // keeps track of rating of current recipe
    var ratingVal: Double!
    var numRatingsVal: Double!
    
    private let padding: CGFloat = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // formats go back button
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        // formats title label
        recipeName.text = currRecipe.getLabel()
        recipeName.font = ColorScheme.pingFang20
        recipeName.textAlignment = .center
        recipeName.lineBreakMode = .byWordWrapping
        recipeName.numberOfLines = 2
        
        // formats recipe image
        let url = URL(string: currRecipe.getImgUrl())
        recipeImg.kf.setImage(with: url)
        recipeImg.layer.masksToBounds = true
        recipeImg.layer.cornerRadius = 7.0
        
        // formats save button
        save.setTitle("Save", for: .normal)
        save.titleLabel!.font = ColorScheme.pingFang18
        save.setTitleColor(ColorScheme.black, for: .normal)
        save.backgroundColor = ColorScheme.green
        save.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        save.layer.cornerRadius = padding
        
        // formats rate button
        tried.setTitle("Rate", for: .normal)
        tried.titleLabel!.font = ColorScheme.pingFang18
        tried.setTitleColor(ColorScheme.black, for: .normal)
        tried.backgroundColor = ColorScheme.yellow
        tried.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        tried.layer.cornerRadius = padding
        
        self.recipeInfoTable.delegate = self
        self.recipeInfoTable.dataSource = self
        self.recipeInfoTable.estimatedRowHeight = 100.0
        self.recipeInfoTable.rowHeight = UITableView.automaticDimension
        
        // initializes firebase database references
        ref = Database.database().reference()
        userRef = ref.child("users").child(Auth.auth().currentUser!.uid)
        recipeRef = Database.database().reference()
        
        // gets recipe rating from firebase database, formats displayed stars
        getRating(id: currRecipe.getId())
    
        rating.settings.fillMode = .precise
        rating.settings.starSize = 30
        rating.settings.filledColor = ColorScheme.pink
        rating.settings.updateOnTouch = false
        
        numRatings.font = ColorScheme.pingFang18
        numRatings.numberOfLines = 2
    }
    
    // tableview methods help populate table of displayed recipe attributes
    func tableView(_ tableView: UITableView, numberOfSections numSections: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedAttributes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == displayedAttributes.count - 1 {
            print(displayedAttributes[indexPath.row][1])
            let svc = SFSafariViewController(url: URL(string: displayedAttributes[indexPath.row][1])!)
            present(svc, animated: true, completion: nil)
        }
    }
    
    // accesses recipe rating from recipe branch of firebase database
    func getRating(id: String) {
        ref.child("recipes").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                self.ratingVal = 0
                self.numRatingsVal = 0
            } else {
                if snapshot.hasChildren() {
                    if snapshot.hasChild(id) {
                        self.numRatingsVal = snapshot.childSnapshot(forPath: id).childSnapshot(forPath: "numRatings").value as? Double ?? 0
                        self.ratingVal = snapshot.childSnapshot(forPath: id).childSnapshot(forPath: "rating").value as? Double ?? 0
                    } else {
                        self.ratingVal = 0
                        self.numRatingsVal = 0
                    }
                } else {
                    self.ratingVal = 0
                    self.numRatingsVal = 0
                }
            }
            self.rating.rating = self.ratingVal
            self.numRatings.text = String(Int(self.numRatingsVal)) + " ratings"
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeInfoTable.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! RecipeInfoTableViewCell
        
        let entry: String = displayedAttributes![indexPath.row][0]
        cell.recipeAttribute.text = entry
        cell.recipeAttribute.font = ColorScheme.pingFang18b
        
        let value: String = displayedAttributes![indexPath.row][1]
        if indexPath.row == displayedAttributes.count - 1 {
            cell.recipeAttributeValue.text = "Link"
            cell.recipeAttributeValue.textColor = UIColor.blue
        } else {
            cell.recipeAttributeValue.text = value
        }
        cell.recipeAttributeValue.font = ColorScheme.pingFang18
        
        return cell
    }
    
    // allow variable heights of cells (useful for ingredients row)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // called when save button is pressed
    @IBAction func saveRecipe(_ sender: Any) {
        writeSavedRecipe(id: currRecipe.getId())
    }
    
    // writes url of saved recipe to user branch & recipe-specific info to recipe branch of database
    func writeSavedRecipe(id: String) {
        ref.child("recipes").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                if !snapshot.hasChild(id) {
                    self.ref.child("recipes").child(id).updateChildValues(self.currRecipe.allAttributesDict())
                }
            } else {
                self.ref.child("recipes").child(id).setValue(self.currRecipe.allAttributesDict())
            }
        })
        
        userRef.child("savedRecipes").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                if !(snapshot.value as? [String] ?? []).contains(id) {
                    self.userRef.updateChildValues(["savedRecipes": (snapshot.value as? [String] ?? []) + [id]])
                }
            } else {
                self.userRef.updateChildValues(["savedRecipes": [id]])
            }
        })
    }
    
    // called when rate button is pressed (moves to rating controller)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "rate" {
            let ratingController: RatingViewController = segue.destination as! RatingViewController
            ratingController.imageToRate = recipeImg.image
            ratingController.currRecipe = currRecipe
            ratingController.recipeNameText = currRecipe.getLabel()
        }
    }
    
    @IBAction func unwindToRecipeZoom(segue: UIStoryboardSegue) {
        
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
