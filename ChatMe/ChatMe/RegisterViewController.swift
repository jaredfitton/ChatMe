//
//  RegisterViewController.swift
//  CSAImpactHub
//
//  Created by Jared Fitton on 10/15/16.
//  Copyright © 2016 Jared Fitton. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var name: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        name.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if email.isEditing {
            email.resignFirstResponder()
        } else if password.isEditing {
            password.resignFirstResponder()
        } else if confirmPassword.isEditing {
            confirmPassword.resignFirstResponder()
        } else if name.isEditing {
            name.resignFirstResponder()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if confirmPassword.isEditing && self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 110
            print("was done")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.name {
            email.becomeFirstResponder()
        }
        if textField == self.email {
            password.becomeFirstResponder()
        }
        if textField == self.password {
            confirmPassword.becomeFirstResponder()
        }
        if textField == self.confirmPassword {
            textField.resignFirstResponder()
            attemptToCreateAccount()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.view.frame.size.height < 568 && textField == self.confirmPassword {
            self.view.frame.origin.y -= 110
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        attemptToCreateAccount()
    }
    
    func attemptToCreateAccount() {
        if password.text! != "" || confirmPassword.text! != "" || email.text! != "" || name.text! != "" {
            if password.text! == confirmPassword.text! {
                if password.text!.characters.count >= 6 {
                    FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: {
                        user, error in
                        
                        if error == nil {
                            print("Account Created")
                            self.createAccount()
                            self.alert(title: "Success", message: "Account Created")
                        }
                        else {
                            print(error!)
                            self.alert(title: "Error", message: "Email is invalid or already in use")
                        }
                    })
                } else {
                    self.alert(title: "Error", message: "Password must be 6 characters long or more")
                }
            } else {
                print("Passwords do not match")
                self.alert(title: "Error", message: "Passwords do not match")
            }
        } else {
            self.alert(title: "Error", message: "Fill in all fields")
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAccount() {
        let ref = FIRDatabase.database().reference()
        
        if let user = FIRAuth.auth()?.currentUser {
            ref.child("users").child(user.uid)
            ref.child("users").child(user.uid).child("Name").setValue(name.text!)
            ref.child("users").child(user.uid).child("Email").setValue(email.text!)
            ref.child("users").child(user.uid).child("Used Codes").setValue(["codes"])
            ref.child("users").child(user.uid).child("Points").setValue(0)
            
            func login(action: UIAlertAction) {
                FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: {
                    user, error in
                    
                    if error != nil {
                        self.alert(title: "Error", message: "Something went wrong, try again")
                    } else {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            }
            
            let alert = UIAlertController(title: "Success", message: "Account Created", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: login))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            alert(title: "Try again", message: "Something went wrong")
        }
    }
    
    
}
