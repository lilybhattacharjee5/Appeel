//
//  AnalyticsAvailableTableViewCell.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/12/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

// used in current status controller to display available usage analytics
class AnalyticsAvailableTableViewCell: UITableViewCell {

    @IBOutlet var analyticsName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
