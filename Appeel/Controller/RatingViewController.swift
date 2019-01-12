//
//  RatingViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/11/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseDatabase
import FirebaseAuth

// displays a page on which the user can submit a rating for the recipe they were viewing
class RatingViewController: ViewController {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var ratedRecipeImage: UIImageView!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var myRating: CosmosView!
    @IBOutlet var submitRating: UIButton!
    @IBOutlet var recipeName: UILabel!
    
    // elements that are set during the segue so info is transferred from recipe zoom controller
    var imageToRate: UIImage!
    var recipeNameText: String!
    var currRecipe: Recipe!
    
    // firebase database references
    var ref: DatabaseReference! // general ref (both users & recipes are children)
    var userRef: DatabaseReference!
    
    private let padding: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set back button appearance
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        // set rate label appearance (says "Rate")
        rateLabel.text = "Rate"
        rateLabel.font = ColorScheme.cochinItalic50
        rateLabel.textColor = ColorScheme.red
        
        // sets rating star display appearance
        myRating.settings.starSize = 50
        myRating.rating = 3
        myRating.settings.filledColor = ColorScheme.pink
        
        // sets the image & text of the recipe to be rated
        ratedRecipeImage.image = imageToRate
        
        recipeName.text = recipeNameText
        recipeName.font = ColorScheme.pingFang18
        recipeName.textAlignment = .center
        recipeName.numberOfLines = 2
        recipeName.lineBreakMode = .byWordWrapping
        
        // formats submit rating button
        submitRating.setTitle("Submit Rating", for: .normal)
        submitRating.titleLabel!.font = ColorScheme.pingFang24
        submitRating.setTitleColor(ColorScheme.black, for: .normal)
        submitRating.backgroundColor = ColorScheme.pink
        submitRating.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        submitRating.layer.cornerRadius = padding
        
        // initializes reference values
        ref = Database.database().reference()
        userRef = ref.child("users").child(Auth.auth().currentUser!.uid)
    }
    
    // executes when button to submit rating is pressed
    @IBAction func saveRating(_ sender: Any) {
        let alert = UIAlertController(title: "Submit Rating", message: "Would you like to submit this rating?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.userRef.child("ratedRecipes").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    if (snapshot.value as? [String: Int] ?? [:])[self.currRecipe.getId()] != nil {
                        let pastVal: Int = (snapshot.value as? [String: Int] ?? [:])[self.currRecipe.getId()] ?? 0
                        self.userRef.child("ratedRecipes").updateChildValues([self.currRecipe.getId(): self.myRating.rating])
                        self.addRating(first: false, past: pastVal)
                    } else {
                        self.userRef.child("ratedRecipes").updateChildValues([self.currRecipe.getId(): self.myRating.rating])
                        self.addRating(first: true, past: 0)
                    }
                } else {
                    self.userRef.updateChildValues(["ratedRecipes": [self.currRecipe.getId(): self.myRating.rating]])
                    self.addRating(first: true, past: 0)
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // handles the rating "star" data
    private func addRating(first: Bool, past: Int) {
        ref.child("recipes").observeSingleEvent(of: .value, with: { (snapshot) in
            var dict: [String: Any]
            // if the recipe is the first to be rated, there won't be a "recipe" child
            if snapshot.exists() {
                // if the user is rating the same recipe again, their latest rating will replace the previous one
                if snapshot.childSnapshot(forPath: self.currRecipe.getId()).exists() {
                    let currRating: Double = snapshot.childSnapshot(forPath: self.currRecipe.getId()).childSnapshot(forPath: "rating").value as? Double ?? 0.0
                    let currNum: Double = snapshot.childSnapshot(forPath: self.currRecipe.getId()).childSnapshot(forPath: "numRatings").value as? Double ?? 0.0
                    var newRating: Double
                    var newNum: Double
                    if first {
                        newNum = currNum + 1
                        newRating = (currRating * currNum + self.myRating.rating) / newNum
                    } else {
                        newNum = currNum
                        newRating = (currRating * currNum - Double(past) + self.myRating.rating) / currNum
                    }
                    dict = ["rating": newRating, "numRatings": currNum + 1]
                } else {
                    dict = ["rating": self.myRating.rating, "numRatings": 1]
                }
                self.ref.child("recipes").updateChildValues([self.currRecipe.getId(): dict]) // adds recipe id & rating into recipe data for existing recipe
            } else {
                dict = ["rating": self.myRating.rating, "numRatings": 1]
                self.ref.child("recipes").setValue([self.currRecipe.getId(): dict]) // adds new recipe to recipe data tree
            }
            self.ref.child("recipes").child(self.currRecipe.getId()).updateChildValues(self.currRecipe.allAttributesDict()) // adds all other recipe attributes
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
