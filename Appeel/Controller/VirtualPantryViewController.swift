//
//  VirtualPantryViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class VirtualPantryViewController: UIViewController {

    @IBOutlet var virtualPantryLabel: UILabel!
    @IBOutlet var tabDisplay: UITabBarItem!
    @IBOutlet var virtualPantryItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        virtualPantryLabel.text = "Virtual Pantry"
        virtualPantryLabel.textColor = ColorScheme.red
        virtualPantryLabel.font = ColorScheme.cochinItalic60
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
