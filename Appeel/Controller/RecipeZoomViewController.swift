//
//  RecipeZoomViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/7/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeZoomViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var recipeImg: UIImageView!
    @IBOutlet var save: UIButton!
    @IBOutlet var favorite: UIButton!
    @IBOutlet var tried: UIButton!
    @IBOutlet var recipeInfoTable: UITableView!
    
    var currRecipe: Recipe!
    var displayedAttributes: [[String]]!
    
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
        
        favorite.setTitle("Fave", for: .normal)
        favorite.titleLabel!.font = ColorScheme.pingFang18
        favorite.setTitleColor(ColorScheme.black, for: .normal)
        favorite.backgroundColor = ColorScheme.pink
        favorite.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        favorite.layer.cornerRadius = padding
        
        tried.setTitle("Tried", for: .normal)
        tried.titleLabel!.font = ColorScheme.pingFang18
        tried.setTitleColor(ColorScheme.black, for: .normal)
        tried.backgroundColor = ColorScheme.yellow
        tried.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        tried.layer.cornerRadius = padding
        
        self.recipeInfoTable.delegate = self
        self.recipeInfoTable.dataSource = self
        self.recipeInfoTable.estimatedRowHeight = 100.0
        self.recipeInfoTable.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfSections numSections: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeInfoTable.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! RecipeInfoTableViewCell
        
        let entry: String = displayedAttributes![indexPath.row][0]
        cell.recipeAttribute.text = entry
        cell.recipeAttribute.font = ColorScheme.pingFang18b
        
        let value: String = displayedAttributes![indexPath.row][1]
        cell.recipeAttributeValue.text = value
        cell.recipeAttributeValue.font = ColorScheme.pingFang18
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
