//
//  LoginViewController.swift
//  CSAImpactHub
//
//  Created by Jared Fitton on 10/14/16.
//  Copyright © 2016 Jared Fitton. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if email.isEditing {
            email.resignFirstResponder()
        } else if password.isEditing {
            password.resignFirstResponder()
        }
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.email {
            password.becomeFirstResponder()
            print("Pressed Next")
        } else if textField == self.password {
            textField.resignFirstResponder()
            login()
        }
        return true
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        login()
    }
    
    func login() {
        if password.text! != "" && email.text! != "" {
            
            FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: {
                user, error in
                
                if error == nil {
                    self.performSegue(withIdentifier: "segueToMainScreen", sender: nil)
                    self.password.text = ""
                }
                else {
                    print("Incorrect password or email")
                    self.alert(title: "Error", message: "Incorrect Email or Password")
                }
            })
        } else {
            self.alert(title: "Error", message: "Fill in all fields")
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
