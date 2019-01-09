//
//  HomeViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/4/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var appName: UILabel!
    @IBOutlet var logIn: UIButton!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var about: UIButton!
    @IBOutlet var miniLogo: UIImageView!
    
    let padding: CGFloat = 50.0
    let borderRadius: CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logIn.setTitle("Log In", for: .normal)
        signUp.setTitle("Sign Up", for: .normal)
        about.setTitle("About", for: .normal)
        
        miniLogo.image = UIImage(named: "apple.png")
        
        appName.font = ColorScheme.cochinItalic60
        appName.textColor = ColorScheme.red
        
        logIn.backgroundColor = ColorScheme.green
        logIn.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        logIn.layer.cornerRadius = borderRadius
        logIn.titleLabel!.font = ColorScheme.pingFang24
        logIn.setTitleColor(ColorScheme.black, for: .normal)
        
        signUp.backgroundColor = ColorScheme.pink
        signUp.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        signUp.layer.cornerRadius = borderRadius
        signUp.titleLabel!.font = ColorScheme.pingFang24
        signUp.setTitleColor(ColorScheme.black, for: .normal)
        
        about.backgroundColor = ColorScheme.yellow
        about.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        about.layer.cornerRadius = borderRadius
        about.titleLabel!.font = ColorScheme.pingFang24
        about.setTitleColor(ColorScheme.black, for: .normal)
    }
    
    @IBAction func loginSegue(_ sender: Any) {
        performSegue(withIdentifier: "logIn", sender: sender)
    }
    
    @IBAction func signUpSegue(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: sender)
    }
    
    
    @IBAction func aboutSegue(_ sender: Any) {
        performSegue(withIdentifier: "about", sender: sender)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
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
