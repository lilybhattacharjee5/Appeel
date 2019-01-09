//
//  RecipeTableViewCell.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/6/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet var previewImg: UIImageView!
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var timeToPrepare: UILabel!
    @IBOutlet var calories: UILabel!
    
    var recipe: Recipe!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
