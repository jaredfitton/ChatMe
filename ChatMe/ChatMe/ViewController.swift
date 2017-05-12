//
//  ViewController.swift
//  ChatMe
//
//  Created by Jared Fitton on 5/5/17.
//  Copyright © 2017 JaredFitton. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let refreshedToken = FIRInstanceID.instanceID().token(){
            print(refreshedToken)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

