//
//  RatingViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/11/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Cosmos

class RatingViewController: ViewController {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var ratedRecipeImage: UIImageView!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var myRating: CosmosView!
    @IBOutlet var submitRating: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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