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
    
    private let borderRadius: CGFloat = 10.0
    private let padding: CGFloat = 20.0
    
    // firebase database reference
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // setup label names
        signupLabel.text = "Signup"
        firstNameLabel.text = "First Name"
        lastNameLabel.text = "Last Name"
        emailLabel.text = "Email"
        passwordLabel.text = "Password"
        
        // setup button formatting
        signupButton.setTitle("Sign Up", for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.setImage(PageViewController.backButtonImg, for: .normal)
        
        // password text will be obscured
        passwordTextField.isSecureTextEntry = true
        
        // initializes database reference
        ref = Database.database().reference()
        
        // formats all text labels
        signupLabel.font = ColorScheme.cochinItalic60
        signupLabel.textColor = ColorScheme.red
        
        firstNameLabel.font = ColorScheme.pingFang20
        lastNameLabel.font = ColorScheme.pingFang20
        emailLabel.font = ColorScheme.pingFang20
        passwordLabel.font = ColorScheme.pingFang20
        
        // formats all text fields
        firstNameTextField.font = ColorScheme.pingFang18
        lastNameTextField.font = ColorScheme.pingFang18
        emailTextField.font = ColorScheme.pingFang18
        passwordTextField.font = ColorScheme.pingFang18
        
        // formats all buttons
        signupButton.backgroundColor = ColorScheme.pink
        signupButton.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        signupButton.layer.cornerRadius = borderRadius
        signupButton.titleLabel!.font = ColorScheme.pingFang24
        signupButton.setTitleColor(ColorScheme.black, for: .normal)
        
        // allows user to tap to make the keyboard disappear
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // signs the user up if they don't already have an account using firebase email / password authentication
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
                    let userInfo = UserProfile(email: email, firstName: firstName, lastName: lastName, imgCounter: 0).toDict()
                    let childRef = Database.database().reference(withPath: "users")
                    childRef.child((Auth.auth().currentUser?.uid)!).setValue(userInfo)
                    let accountCreatedController = UIAlertController(title: "Account Created", message: "The new account was successfully created.", preferredStyle: .alert)
                    let specialAction = UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                        self.performSegue(withIdentifier: "signupToLogin", sender: sender)
                    })
                    accountCreatedController.addAction(specialAction)
                    self.present(accountCreatedController, animated: true, completion: nil)
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
