//
//  PantryItemTableViewCell.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/9/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class PantryItemTableViewCell: UITableViewCell {

    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
