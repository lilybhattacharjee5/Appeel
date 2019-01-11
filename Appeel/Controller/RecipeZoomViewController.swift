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

class RecipeZoomViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var rating: CosmosView!
    @IBOutlet var goBack: UIButton!
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var recipeImg: UIImageView!
    @IBOutlet var save: UIButton!
    @IBOutlet var tried: UIButton!
    @IBOutlet var recipeInfoTable: UITableView!
    @IBOutlet var numRatings: UILabel!
    
    var currRecipe: Recipe!
    var displayedAttributes: [[String]]!
    
    var userRef: DatabaseReference!
    var recipeRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        recipeName.text = currRecipe.getLabel()
        recipeName.font = ColorScheme.pingFang20
        recipeName.textAlignment = .center
        recipeName.lineBreakMode = .byWordWrapping
        recipeName.numberOfLines = 2
        
        let url = URL(string: currRecipe.getImgUrl())
        recipeImg.kf.setImage(with: url)
        recipeImg.layer.masksToBounds = true
        recipeImg.layer.cornerRadius = 7.0
        
        let padding: CGFloat = 5.0
        
        save.setTitle("Save", for: .normal)
        save.titleLabel!.font = ColorScheme.pingFang18
        save.setTitleColor(ColorScheme.black, for: .normal)
        save.backgroundColor = ColorScheme.green
        save.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        save.layer.cornerRadius = padding
        
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
    
        rating.settings.starSize = 30
        rating.rating = 0
        rating.settings.updateOnTouch = false
        
        numRatings.font = ColorScheme.pingFang18
        numRatings.text = "0 ratings"
        
        userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        recipeRef = Database.database().reference()
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @IBAction func saveRecipe(_ sender: Any) {
        writeSavedRecipe(id: currRecipe.getId())
    }
    
    @IBAction func rateRecipe(_ sender: Any) {
//        var rate: CosmosView = CosmosView()
//        rate.rating = 5
//        rate.text = "Rate this recipe!"
//        rate.didTouchCosmos = {
//            rating in
//        }
//        rate.didFinishTouchingCosmos = {
//            rating in
//        }
    }
    
    func writeSavedRecipe(id: String) {
        userRef.child("savedRecipes").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChildren() {
                if !snapshot.hasChild(id) {
                    self.userRef.child("savedRecipes").updateChildValues([id: self.currRecipe.allAttributesDict()])
                }
            } else {
                self.userRef.child("savedRecipes").setValue([id: self.currRecipe.allAttributesDict()])
            }
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
