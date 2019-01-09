//
//  AboutViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/4/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        aboutLabel.text = "About"
        backButton.setTitle("", for: .normal)
        backButton.setImage(PageViewController.backButtonImg, for: .normal)
        
        aboutLabel.font = ColorScheme.cochinItalic60
        aboutLabel.textColor = ColorScheme.red
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
