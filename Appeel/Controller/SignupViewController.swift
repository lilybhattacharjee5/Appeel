//
//  SignupViewController.swift
//  Appeel
//
//  Created by Lily Bhattacharjee on 1/4/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet var signupLabel: UILabel!
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var backButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signupLabel.text = "Signup"
        firstNameLabel.text = "First Name"
        lastNameLabel.text = "Last Name"
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
        
        signupButton.setTitle("Sign Up", for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.setImage(PageViewController.backButtonImg, for: .normal)
        
        passwordTextField.isSecureTextEntry = true
        
        ref = Database.database().reference()
        
        signupLabel.font = ColorScheme.cochinItalic60
        signupLabel.textColor = ColorScheme.red
        
        firstNameLabel.font = ColorScheme.pingFang20
        lastNameLabel.font = ColorScheme.pingFang20
        emailLabel.font = ColorScheme.pingFang20
        passwordLabel.font = ColorScheme.pingFang20
        
        firstNameTextField.font = ColorScheme.pingFang18
        lastNameTextField.font = ColorScheme.pingFang18
        emailTextField.font = ColorScheme.pingFang18
        passwordTextField.font = ColorScheme.pingFang18
        
        let borderRadius: CGFloat = 10.0
        let padding: CGFloat = 20.0
        
        signupButton.backgroundColor = ColorScheme.pink
        signupButton.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        signupButton.layer.cornerRadius = borderRadius
        signupButton.titleLabel!.font = ColorScheme.pingFang24
        signupButton.setTitleColor(ColorScheme.black, for: .normal)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let email: String = emailTextField.text else { return }
        guard let password: String = passwordTextField.text else { return }
        guard let firstName: String = firstNameTextField.text else { return }
        guard let lastName: String = lastNameTextField.text else { return }
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        if email == "" || password == "" || firstName == "" || lastName == "" {
            print("error")
            let notFilledController = UIAlertController(title: "Form Error", message: "Please fill in all required fields.", preferredStyle: .alert)
            notFilledController.addAction(defaultAction)
            present(notFilledController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if error == nil {
                    let userInfo = UserProfile(email: email, firstName: firstName, lastName: lastName).toDict()
                    let childRef = Database.database().reference(withPath: "users")
                    childRef.child((Auth.auth().currentUser?.uid)!).setValue(userInfo)
                    let accountCreatedController = UIAlertController(title: "Account Created", message: "The new account was successfully created.", preferredStyle: .alert)
                    accountCreatedController.addAction(defaultAction)
                    self.present(accountCreatedController, animated: true, completion: nil)
                    self.performSegue(withIdentifier: "signupToLogin", sender: sender)
                } else {
                    let formErrorController = UIAlertController(title: "Form Error", message: "There was an error while creating this account. Please try again.", preferredStyle: .alert)
                    formErrorController.addAction(defaultAction)
                    self.present(formErrorController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "goBackSignup", sender: sender)
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
