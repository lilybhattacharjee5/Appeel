//
//  PantrySearchViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/8/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class PantrySearchViewController: ViewController {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var pantrySearchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goBack.setTitle("", for: .normal)
        goBack.setBackgroundImage(UIImage(named: "back-button.png"), for: .normal)
        
        pantrySearchLabel.text = "Pantry Search"
        pantrySearchLabel.textColor = ColorScheme.red
        pantrySearchLabel.font = ColorScheme.cochinItalic50
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
