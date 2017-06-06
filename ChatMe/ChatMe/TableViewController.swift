//
//  TableViewController.swift
//  ChatMe
//
//  Created by Mobile on 5/22/17.
//  Copyright © 2017 JaredAlberto. All rights reserved.
//

/*
 look up
 user defaults
 
 */

import UIKit
import Firebase

class TableViewController: UITableViewController {
    let ref = FIRDatabase.database().reference()
    var convos: [Conversation]!
    var alertTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        convos = [Conversation]()
        
        alertTextField = UITextField()
        
        loadConversations()
        
        
//        self.ref.child("Users/jaredfitton").observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot.value)
//        })
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadConversations() {
        //load convo ids from firebase
        var username = ""
        ref.child("Usernames/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
            username = snapshot.value as! String
            
            self.ref.child("Users/\(username)/Conversation_Tokens").observeSingleEvent(of: .value, with: { (snapshot) in
                if let token = snapshot.value as? [String] {
                    for t in token {
                        self.convos.insert(Conversation(conversationToken: t, tableView: self.tableView), at: 0)
                    }
                }
            })
        })
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return convos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Conversation", for: indexPath) as! TableViewCell

        let conversation = convos[indexPath.row]
        let allRecipients = conversation.getRecipients()
        var recipients = allRecipients[0]
        
        if allRecipients.count > 1 {
            for i in 1...allRecipients.count-1 {
                recipients.append(", \(allRecipients[i])")
            }
        }
        
        cell.name.text = recipients
        cell.message.text = conversation.getMessages().last?[1] 

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    @IBAction func newMessage(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Conversation", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
            self.alertTextField = textField
            textField.placeholder = "Enter Recipient's Username"
        })
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: {
            alert -> Void in
            print(self.alertTextField.text!)
            self.ref.child("Usernames/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.value as! String) != self.alertTextField.text! {
                    let newConvo = Conversation(recipients: [self.alertTextField.text!], tableView: self.tableView)
                    self.convos.insert(newConvo, at: 0)
                    print("Created New Convo")
                } else {
                    print("Not Created")
                }
            })
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let convoVC = segue.destination as! CoversationViewController
        
        let indexPath = tableView.indexPath(for: sender as! TableViewCell)!
        let selectedConvo = convos[indexPath.row]
        convoVC.conversation = selectedConvo
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
