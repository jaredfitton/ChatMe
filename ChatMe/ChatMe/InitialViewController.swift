//
//  InitialViewController.swift
//  CSAImpactHub
//
//  Created by Jared Fitton on 10/31/16.z
//  Copyright © 2016 Jared Fitton. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //try! FIRAuth.auth()?.signOut()
        
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "toMainScreen", sender: nil)
        }
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
    }
    
}
