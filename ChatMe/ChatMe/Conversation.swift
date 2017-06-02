//
//  Conversation.swift
//  Pods
//
//  Created by Jared Fitton on 5/19/17.
//
//

import Foundation
import Firebase

class Conversation {

    var numberOfUsedCodes: Int!
    
    var conversationToken: String! {
        didSet {
            addConversationTokensToFirebase()
        }
    }
    var currentUser: String
    var messages: [[String]]!
    var recipients: [String]!
    var ref = FIRDatabase.database().reference()

    init(conversationToken: String, tableView: UITableView) {
        
        self.conversationToken = conversationToken
        messages = [[String]]()
        numberOfUsedCodes = 0
        currentUser = ""
        
        ref.child("Conversations/\(conversationToken)/Recipients").observeSingleEvent(of: .value, with: { (snapshot) in
            var users = snapshot.value as! [String]
            
            self.ref.child("Usernames/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
                self.currentUser = snapshot.value as! String
                for i in 0...(users.count-1) {
                    if users[i] == self.currentUser {
                        users.remove(at: i)
                        break
                    }
                }
                self.recipients = users
                tableView.reloadData()
                print(self.recipients)
            })
        })
    }
    
    init(recipients: [String]) {
        self.recipients = recipients
        currentUser = ""
        messages = [[String]]()

        ref.child("UsedConversationTokens").observeSingleEvent(of: .value, with: { (snapshot) in //Get used tokens from Firebase
            let usedCodes = snapshot.value as! [String]
            self.numberOfUsedCodes = usedCodes.count
            self.conversationToken = self.generateToken(usedCodes: usedCodes) //Generate a new token for this conversation
            
            self.ref.child("Usernames/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
                self.currentUser = snapshot.value as! String
                var users = recipients
                for i in 0...(users.count-1) {
                    if users[i] == self.currentUser {
                        users.remove(at: i)
                        break
                    }
                }
                self.recipients = users
                print(self.recipients)
            })
            
            self.ref.child("Conversations/\(self.conversationToken!)/Recipients").setValue(self.getRecipients())
        })
        
    }
    
    func getRecipients() -> [String] {
        return recipients
    }
   
    func getConversationToken() -> String {
        return conversationToken
    }
    
    func getCurrentUser() -> String {
        return currentUser
    }
    
    func generateToken(usedCodes: [String]) -> String {
        var token = randomString(length: 10)
        
        while usedCodes.contains(token) {
            token = randomString(length: 10)
        }
        return token
    }
    
    func addConversationTokensToFirebase() {
        self.ref.child("UsedConversationTokens").updateChildValues(["\(self.numberOfUsedCodes!)":self.conversationToken])
        //Add Conversation Token to UsedConversationTokens on Firebase
        
        for userName in recipients { //Add Conversation Token to each recipient's list of conversations
            ref.child("Users/\(userName)/Conversation_Tokens").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var numberOfConversations: Int?
                numberOfConversations = Int(snapshot.childrenCount)
                
                if numberOfConversations == nil {
                    numberOfConversations = 0
                }
                self.ref.child("Users/\(userName)/Conversation_Tokens").updateChildValues(["\(numberOfConversations!)":self.conversationToken])
                
                
                let UID = FIRAuth.auth()?.currentUser?.uid
                self.ref.child("Usernames/\(UID!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    if (snapshot.value! as! String) == userName {
                        print("Found")
                    }
                })
            
            })
        }
    }
    
    func getMessages() -> [[String]] {
        return messages
    }
    
    func addMessage(message: [String]) {
        messages.append(message)
    }
    
    func sendMessage(message: String) {
        messages.append([currentUser, message])
        
        for user in recipients! {
            ref.child("Conversations/\(conversationToken!)/\(user)").observeSingleEvent(of: .value, with: { (snapshot) in
                let messageCount = snapshot.childrenCount
                self.ref.child("Conversations/\(self.conversationToken!)/\(user)/\(messageCount)").updateChildValues([self.currentUser:message])
            })
        }
    }
    
    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
}
