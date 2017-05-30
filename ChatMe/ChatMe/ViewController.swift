//
//  ViewController.swift
//  ChatMe
//
//  Created by Jared Fitton on 5/17/17.
//  Copyright © 2017 JaredAlberto. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.signIn(withEmail: "jaredfitton@gmail.com", password: "password", completion: { user, error in
            if error == nil {
            print("Logged In")
            } else {
            print("Error")
            }
        })

        
        //var testConvo = Conversation(recipients: ["alberto8gil","jaredfitton"])
        var joinConvo = Conversation(conversationToken: "4PtJYJ0FA2")
        //print(joinConvo.getRecipients())
    }

    

}

