//
//  PhotoResultsTableViewCell.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/10/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

// used to display all matches for ingredients from a photo input into Clarifai's Food Model API
class PhotoResultsTableViewCell: UITableViewCell {

    @IBOutlet var conceptName: UILabel!
    @IBOutlet var probability: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
