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
        
//        ref.child("Conversations").observe(FIRDataEventType.value, with: { (snapshot) in
//            print("Children: \(snapshot.value)")
//            let dict = snapshot.value as! Dictionary<String, AnyObject>
//            let keys = Array(dict.keys)
//            print(keys)
//        })

        
        var testConvo = Conversation(recipients: [["jaredfiton", "Jared"],["alberto8gil", "Alberto"]])
    }

    

}

