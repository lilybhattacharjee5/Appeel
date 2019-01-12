//
//  PantrySearchTableViewCell.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/10/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

// used to display food items in the user's virtual pantry to do a pantry-specific search
class PantrySearchTableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var brand: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
