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
    }
    
    @IBAction func saveRating(_ sender: Any) {
        ref.child("recipes").observeSingleEvent(of: .value, with: { (snapshot) in
            var dict: [String: Any]
            if snapshot.exists() {
                if snapshot.childSnapshot(forPath: self.currRecipe.getId()).exists() {
                    let currRating: Double = snapshot.childSnapshot(forPath: self.currRecipe.getId()).childSnapshot(forPath: "rating").value as? Double ?? 0.0
                    let currNum: Double = snapshot.childSnapshot(forPath: self.currRecipe.getId()).childSnapshot(forPath: "numRatings").value as? Double ?? 0.0
                    dict = ["rating": (currRating * currNum + self.myRating.rating) / (currNum + 1), "numRatings": currNum + 1]
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
