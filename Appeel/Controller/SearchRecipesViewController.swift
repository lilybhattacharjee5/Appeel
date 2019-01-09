//
//  SearchRecipesViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class SearchRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var exploreRecipesLabel: UILabel!
    @IBOutlet var tabDisplay: UITabBarItem!
    @IBOutlet var randomRecipe: UIButton!
    @IBOutlet var searchByIngred: UIButton!
    @IBOutlet var generalSearch: UIButton!
    @IBOutlet var displayedRecipes: UITableView!
    
    var query: String = "chicken breast"
    var from: Int = 0
    var to: Int = 10
    var ingr: Int = Int.max
    var diet: String = ""
    var health: [String] = []
    var calories: String = ""
    var time: String = ""
    var excluded: [String] = []
    
    let appId: String = "a4c5cb52"
    let appKey: String = "2df4ac35c025f1afe9ae4123fea86d63"
    
    var finalRecipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.exploreRecipesLabel.text = "Explore Recipes"
        self.exploreRecipesLabel.textColor = ColorScheme.red
        self.exploreRecipesLabel.font = ColorScheme.cochinItalic50
        
        let padding: CGFloat = 10.0
        
        randomRecipe.titleLabel!.font = ColorScheme.pingFang18
        randomRecipe.setTitleColor(ColorScheme.black, for: .normal)
        randomRecipe.backgroundColor = ColorScheme.green
        randomRecipe.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        randomRecipe.layer.cornerRadius = padding
        
        searchByIngred.titleLabel!.font = ColorScheme.pingFang18
        searchByIngred.setTitleColor(ColorScheme.black, for: .normal)
        searchByIngred.backgroundColor = ColorScheme.pink
        searchByIngred.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        searchByIngred.layer.cornerRadius = padding
        
        generalSearch.titleLabel!.font = ColorScheme.pingFang18
        generalSearch.setTitleColor(ColorScheme.black, for: .normal)
        generalSearch.backgroundColor = ColorScheme.yellow
        generalSearch.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        generalSearch.layer.cornerRadius = padding
        
        randomRecipe.setTitle("Random", for: .normal)
        searchByIngred.setTitle("Pantry", for: .normal)
        generalSearch.setTitle("General", for: .normal)
        
        self.displayedRecipes.delegate = self
        self.displayedRecipes.dataSource = self
        
        self.createRecipeList()
        self.displayedRecipes.rowHeight = UITableView.automaticDimension
        self.displayedRecipes.estimatedRowHeight = 100.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.finalRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = displayedRecipes.dequeueReusableCell(withIdentifier: "recipe", for: indexPath) as! RecipeTableViewCell
        let currRecipe = self.finalRecipes[indexPath.row]
        cell.recipe = currRecipe
        
        let entry: String = currRecipe.getLabel()
        cell.recipeName.text = entry
        cell.recipeName.font = ColorScheme.pingFang20
        
        let stringUrl: String = currRecipe.getImgUrl()
        let url = URL(string: stringUrl)
        
        cell.previewImg.kf.setImage(with: url)
        cell.previewImg.translatesAutoresizingMaskIntoConstraints = false
        cell.previewImg.frame = CGRect(x: 0, y: 0, width: 90, height: 100)
        cell.previewImg.layer.masksToBounds = true
        cell.previewImg.layer.cornerRadius = 7.0
        
        cell.timeToPrepare.text = String(Int(round(currRecipe.getTotalTime()))) + " min"
        cell.timeToPrepare.font = ColorScheme.pingFang18
        
        cell.calories.text = String(Int(round(currRecipe.getCalories()))) + " cal"
        cell.calories.font = ColorScheme.pingFang18
        
        return cell
    }
    
    func createRecipeList() {
        accessPage() { response in
            self.finalRecipes = response
            self.displayedRecipes.reloadData()
        }
    }
    
    func accessPage(completionHandler: @escaping ([Recipe]) -> Void) {
//        let finalUrl: String = genUrl()
//        print(finalUrl)
//        let finalUrl: String = "https://api.myjson.com/bins/bd01c"
        let finalUrl: String = "https://api.myjson.com/bins/ic8sg"
        var allRecipes: [Recipe] = []
        AF.request(finalUrl).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                let currPageData = json["hits"]
                var newRecipe: Recipe

                for recipe in self.from...self.to - 1 {
                    var currRecipe = currPageData[recipe]["recipe"]

                    var allIngreds: [Ingredient] = []
                    var currIngred: [String: Any]

                    for ingred in currRecipe["ingredients"].arrayObject! {
                        currIngred = ingred as! [String: Any]
                        allIngreds.append(Ingredient(food: currIngred["text"] as! String, weight: (currIngred["weight"] as? NSNumber)?.floatValue ?? 0))
                    }

                    newRecipe = Recipe(
                        label: currRecipe["label"].string!,
                        imgUrl: currRecipe["image"].string!,
                        source: currRecipe["source"].string!,
                        yield: currRecipe["yield"].float!,
                        calories: currRecipe["calories"].float!,
                        totalTime: currRecipe["totalTime"].float!,
                        totalWeight: currRecipe["totalWeight"].float!,
                        ingredients: allIngreds,
                        totalNutrients: [],
                        totalDaily: [],
                        dietLabels: currRecipe["dietLabels"].arrayObject as! [String],
                        healthLabels: currRecipe["healthLabels"].arrayObject as! [String]
                    )
                    allRecipes.append(newRecipe)
                }
                completionHandler(allRecipes)
            }
        }
    }
    
    func genUrl() -> String {
        var url: String = "https://api.edamam.com/search?q="
        let componentList = self.query.components(separatedBy: " ")
        var counter = 0
        
        for ingred in componentList {
            if counter < componentList.count - 1 {
                url += (ingred + "%20")
            } else {
                url += ingred
            }
            counter += 1
        }
        
        url += ("&app_id=" + self.appId)
        url += ("&app_key=" + self.appKey)
        url += ("&from=" + String(self.from))
        url += ("&to=" + String(to))
        
        if ingr != Int.max {
            url += ("&ingr=" + String(self.ingr))
        }
        
        if diet != "" {
            url += ("&diet=" + self.diet)
        }
        
        if health != [] {
            for healthItem in self.health {
                url += ("&health=" + healthItem)
            }
        }
        
        if calories != "" {
            url += ("&calories=" + self.calories)
        }
        
        if time != "" {
            url += ("&time=" + self.time)
        }
        
        if excluded != [] {
            for excludedItem in self.excluded {
                url += ("&excluded=" + excludedItem)
            }
        }
        
        return url
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "zoomRecipe" {
            let zoomedRecipe: RecipeZoomViewController = segue.destination as! RecipeZoomViewController
            let recipeCell: RecipeTableViewCell = sender as! RecipeTableViewCell
            zoomedRecipe.currRecipe = recipeCell.recipe
            zoomedRecipe.displayedAttributes = recipeCell.recipe.allAttributes()
        }
    }
    
    @IBAction func unwindToSearchRecipesViewController(segue: UIStoryboardSegue) {
        
    }
    
}
