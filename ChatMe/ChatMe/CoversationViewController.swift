//
//  CoversationViewController.swift
//  ChatMe
//
//  Created by Mobile on 5/24/17.
//  Copyright © 2017 JaredAlberto. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore

class CoversationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var conversationScrollView: UIScrollView!
    var contentView: UIView?
    @IBOutlet weak var textField: UITextField!
    var conversation: Conversation!
    let ref = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
//        contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 3000))
//        conversationScrollView.contentSize = (contentView?.bounds.size)!
//        conversationScrollView.addSubview(contentView!)
//        self.view.addSubview(conversationScrollView)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        ref.child("Conversations/\(conversation.getConversationToken())/\(conversation.getCurrentUser())").observe(FIRDataEventType.value, with: { (snapshot) in
            let pulledMessages = snapshot.value as? [[String:String]]
            self.ref.child("Conversations/\(self.conversation.getConversationToken())/\(self.conversation.getCurrentUser())").removeValue()
            if let messages = pulledMessages {
                for m in messages {
                    //Add message to the UI
                    for (key, value) in m {
                        self.conversation.addMessage(message: [key, value])
                    }
                }
            }
            self.loadMessagesIntoView()
        })
    }
    
    func loadMessagesIntoView(){
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: conversation.getMessages().count
        * 55 + 10))
        conversationScrollView.contentSize = (contentView?.bounds.size)!
        conversationScrollView.addSubview(contentView!)
        self.view.addSubview(conversationScrollView)
        print(conversation.getMessages())
        for (i, message) in conversation.getMessages().enumerated(){
            if(message[0] == conversation.getCurrentUser()){
                let label = UILabel(frame: CGRect(x: Int(self.view.frame.width - CGFloat(message[1].characters.count*10)), y: 55 * i + 10, width: message[1].characters.count * 10, height: 50))
                label.text = message[1]
                label.backgroundColor = UIColor.white
                label.layer.masksToBounds = true
                label.layer.cornerRadius = 10
                label.textAlignment = .center
                contentView?.addSubview(label)
            }else{
                let label = UILabel(frame: CGRect(x: 30, y:55 * i + 10, width: message[1].characters.count * 10, height: 50))
                label.text = message[1]
                label.backgroundColor = UIColor.white
                label.layer.masksToBounds = true
                label.layer.cornerRadius = 15
                label.textAlignment = .center
                contentView?.addSubview(label)
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        //Add message to the UI
        conversation.sendMessage(message: textField.text!)
        loadMessagesIntoView()
    }
    
    func keyboardWillAppear(_ notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    func keyboardWillDisappear(_ notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func resignFirstResponder() -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
