//
//  CurrentStatusViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/5/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CurrentStatusViewController: ViewController {

    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var accountNameLabel: UILabel!
    @IBOutlet var tabDisplay: UITabBarItem!
    
    @IBOutlet var logout: UIButton!
    
    var ref: DatabaseReference!

    var currentUser: UserProfile!
    var email: String!
    var firstName: String!
    var lastName: String!
    var imgCounter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.welcomeLabel.text = "Welcome,"
        self.welcomeLabel.textColor = ColorScheme.red
        self.welcomeLabel.font = ColorScheme.pingFang50
        
        let padding: CGFloat = 7.0
        let borderRadius: CGFloat = 5.0
        
        self.logout.setTitle("Log Out", for: .normal)
        self.logout.setTitleColor(ColorScheme.black, for: .normal)
        self.logout.layer.cornerRadius = borderRadius
        self.logout.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.logout.titleLabel!.font = ColorScheme.pingFang18
        self.logout.backgroundColor = ColorScheme.pink
        
        ref = Database.database().reference()
        let rawUser: User = Auth.auth().currentUser!
        ref.child("users").child(rawUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let userInfo = snapshot.value as? NSDictionary
            self.email = userInfo?["email"] as? String ?? ""
            self.firstName = userInfo?["firstName"] as? String ?? ""
            self.lastName = userInfo?["lastName"] as? String ?? ""
            self.imgCounter = userInfo?["imgCounter"] as? Int ?? 0
            self.currentUser = UserProfile(email: self.email, firstName: self.firstName, lastName: self.lastName, imgCounter: self.imgCounter)
            self.accountNameLabel.text = self.firstName + "."
            self.accountNameLabel.textColor = ColorScheme.red
            self.accountNameLabel.font = ColorScheme.cochinItalic50
            self.accountNameLabel.textAlignment = .right
        }) { (error) in
            print(error.localizedDescription)
        }
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
