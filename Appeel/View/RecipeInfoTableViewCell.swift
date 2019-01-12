//
//  RecipeInfoTableViewCell.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/8/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

// used to display various recipe attributes in recipe zoom controller ex. servings, calories
class RecipeInfoTableViewCell: UITableViewCell {

    @IBOutlet var recipeAttribute: UILabel!
    @IBOutlet var recipeAttributeValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
