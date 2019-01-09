//
//  SearchItemTableViewCell.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/9/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class SearchItemTableViewCell: UITableViewCell {

    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var itemCategory: UILabel!
    @IBOutlet var itemBrand: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
