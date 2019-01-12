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

class RatingViewController: ViewController {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var ratedRecipeImage: UIImageView!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var myRating: CosmosView!
    @IBOutlet var submitRating: UIButton!
    
    var imageToRate: UIImage!
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    var currRecipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        rateLabel.text = "Rate"
        rateLabel.font = ColorScheme.cochinItalic50
        rateLabel.textColor = ColorScheme.red
        
        myRating.settings.starSize = 50
        myRating.rating = 3
        
        ratedRecipeImage.image = imageToRate
        
        let padding: CGFloat = 10.0
        
        submitRating.setTitle("Submit Rating", for: .normal)
        submitRating.titleLabel!.font = ColorScheme.pingFang24
        submitRating.setTitleColor(ColorScheme.black, for: .normal)
        submitRating.backgroundColor = ColorScheme.pink
        submitRating.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        submitRating.layer.cornerRadius = padding
        
        ref = Database.database().reference()
        userRef = ref.child("users").child(Auth.auth().currentUser!.uid)
    }
    
    @IBAction func saveRating(_ sender: Any) {
        let alert = UIAlertController(title: "Submit Rating", message: "Is your rating final? You will not be able to change it.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.userRef.child("ratedRecipes").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    if (snapshot.value as? [String: Int] ?? [:])[self.currRecipe.getId()] != nil {
                        let pastVal: Int = (snapshot.value as? [String: Int] ?? [:])[self.currRecipe.getId()] ?? 0
                        self.userRef.child("ratedRecipes").updateChildValues([self.currRecipe.getId(): self.myRating.rating])
                        self.addRating(first: false, past: pastVal)
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
    
    private func addRating(first: Bool, past: Int) {
        ref.child("recipes").observeSingleEvent(of: .value, with: { (snapshot) in
            var dict: [String: Any]
            if snapshot.exists() {
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
                    dict = ["rating": newRating, "numRatings": newNum]
                } else {
                    dict = ["rating": self.myRating.rating, "numRatings": 1]
                }
                self.ref.child("recipes").updateChildValues([self.currRecipe.getId(): dict])
            } else {
                dict = ["rating": self.myRating.rating, "numRatings": 1]
                self.ref.child("recipes").setValue([self.currRecipe.getId(): dict])
            }
            self.ref.child("recipes").child(self.currRecipe.getId()).updateChildValues(self.currRecipe.allAttributesDict())
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
