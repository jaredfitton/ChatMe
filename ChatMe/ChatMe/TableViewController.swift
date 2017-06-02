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
    let array = ["zero","one","two","three","four","five","six"]
    let ref = FIRDatabase.database().reference()
    var convos: [Conversation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        convos = [Conversation]()
        
        loadConversations()
        
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
                let token = snapshot.value as! [String]
                
                for t in token {
                    self.convos.insert(Conversation(conversationToken: t, tableView: self.tableView), at: 0)
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

        let recipientsArray = convos[indexPath.row].getRecipients()
        var recipients = recipientsArray[0]
        
        if recipientsArray.count > 1 {
            for i in 1...recipientsArray.count-1 {
                recipients.append(", \(recipientsArray[i])")
            }
        }
        
        cell.name.text = recipients
        cell.message.text = "Last Message Here."

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
