//
//  LoginViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/4/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginLabel.text = "Login"
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
        loginButton.setTitle("Log In", for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.setImage(PageViewController.backButtonImg, for: .normal)
        passwordTextField.isSecureTextEntry = true
        
        loginLabel.font = ColorScheme.cochinItalic60
        loginLabel.textColor = ColorScheme.red
        
        emailLabel.font = ColorScheme.pingFang20
        passwordLabel.font = ColorScheme.pingFang20
        
        emailTextField.font = ColorScheme.pingFang18
        passwordTextField.font = ColorScheme.pingFang18
        
        let borderRadius: CGFloat = 10.0
        let padding: CGFloat = 20.0
        
        loginButton.backgroundColor = ColorScheme.green
        loginButton.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        loginButton.layer.cornerRadius = borderRadius
        loginButton.titleLabel!.font = ColorScheme.pingFang24
        loginButton.setTitleColor(ColorScheme.black, for: .normal)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        guard let email: String = emailTextField.text else { return }
        guard let password: String = passwordTextField.text else { return }
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        if email == "" || password == "" {
            let notFilledController = UIAlertController(title: "Form Error", message: "Please fill in all required fields.", preferredStyle: .alert)
            notFilledController.addAction(defaultAction)
            present(notFilledController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    let signedInController = UIAlertController(title: "Signed In", message: "You have successfully signed in.", preferredStyle: .alert)
                    let specialAction = UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                        self.performSegue(withIdentifier: "loginAccount", sender: sender)
                    })
                    signedInController.addAction(specialAction)
                    self.present(signedInController, animated: true, completion: nil)
                } else {
                    let formErrorController = UIAlertController(title: "Form Error", message: "There was an error while signing in to this account. Please try again.", preferredStyle: .alert)
                    formErrorController.addAction(defaultAction)
                    self.present(formErrorController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "goBackLogin", sender: self)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return true
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
