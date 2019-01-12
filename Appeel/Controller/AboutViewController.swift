//
//  AboutViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/4/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

// about / info page for the app
class AboutViewController: UIViewController {

    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var aboutText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // formats title label
        aboutLabel.text = "About"
        aboutLabel.font = ColorScheme.cochinItalic60
        aboutLabel.textColor = ColorScheme.red
        
        // formats back button
        backButton.setTitle("", for: .normal)
        backButton.setImage(PageViewController.backButtonImg, for: .normal)
        
        // formats about text label
        aboutText.text = """
        This app was created by Lily Bhattacharjee, a current sophomore at UC Berkeley, as a side project to more deeply explore iOS development and integrating various APIs with data analysis and account / system design. Technologies / APIs used freely during the creation of this app include the following: \n
        \u{2022} Google Firebase Database, Core, Authentication, Storage, UI\n
        \u{2022} SwiftyJSON\n
        \u{2022} Alamofire\n
        \u{2022} Kingfisher\n
        \u{2022} Clarifai API\n
        \u{2022} Edamam Food, Recipe APIs
        \u{2022} Cosmos Star Ratings\n
        \u{2022} iOS Charts + ChartsRealm\n
        """
        aboutText.font = ColorScheme.pingFang18
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "goBackAbout", sender: self)
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
