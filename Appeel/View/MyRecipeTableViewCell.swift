//
//  MyRecipeTableViewCell.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/11/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

// used in my recipe controller to display either saved or rated recipes
class MyRecipeTableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
