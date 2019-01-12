//
//  AccountTabViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

// sets appearances & names of tab bar items for user account
class AccountTabBarController: UITabBarController {
    
    @IBOutlet var accountTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 1

        // Do any additional setup after loading the view.
        let virtualPantry: UITabBarItem = accountTabBar.items![0] as UITabBarItem
        let currentStatus: UITabBarItem = accountTabBar.items![1] as UITabBarItem
        let exploreRecipes: UITabBarItem = accountTabBar.items![2] as UITabBarItem
        
        virtualPantry.title = "Virtual Pantry"
        currentStatus.title = "Current Status"
        exploreRecipes.title = "Explore Recipes"
        
        virtualPantry.image = UIImage(named: "virtual-pantry.png")
        currentStatus.image = UIImage(named: "current-status.png")
        exploreRecipes.image = UIImage(named: "explore-recipes.png")
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
