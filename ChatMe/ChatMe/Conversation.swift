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
    
    var messages: [[String]]!
    var recipients: [[String]]!
    var ref = FIRDatabase.database().reference()

    init(recipients: [[String]], conversationToken: String) {
        self.conversationToken = conversationToken
        
    }
    
    init(recipients: [[String]]) {
        
        self.recipients = recipients
        
        messages = [[]] as! [[String]]

        ref.child("UsedConversationTokens").observeSingleEvent(of: .value, with: { (snapshot) in //Get used tokens from Firebase
            let usedCodes = snapshot.value as! [String]
            self.numberOfUsedCodes = usedCodes.count
            self.conversationToken = self.generateToken(usedCodes: usedCodes) //Generate a new token for this conversation
        })
    }
    
    func getRecipientNames() -> [String] {
        var recipientNames = [] as! [String]
        
        for r in recipients {
            recipientNames.append(r[1])
        }
        
        return recipientNames
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
            ref.child("Users/\(userName[0])/Conversation_Tokens").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var numberOfConversations: Int?
                numberOfConversations = Int(snapshot.childrenCount)
                
                if numberOfConversations == nil {
                    numberOfConversations = 0
                }
                self.ref.child("Users/\(userName[0])/Conversation_Tokens").updateChildValues(["\(numberOfConversations!)":self.conversationToken])
            })
        }
    }
    
    func getMessages() -> [[String]] {
        return messages
    }
    
    func addMessage(message: [String]) {
        messages.append(message)
    }
    
    func sendMessage(message: [String]) {
        messages.append(message)
        
        //Remove the array at the index that contains the senders name
        
        //var peopleToRecieve = recipients
        //peopleToRecieve?.remove(at: 0)
        
        for user in recipients {
            ref.child("Conversations/\(conversationToken!)/\(user[1])").updateChildValues([message[0]:message[1]])
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
