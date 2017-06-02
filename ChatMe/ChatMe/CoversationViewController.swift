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
    @IBOutlet weak var textField: UITextField!
    
    
    var conversation: Conversation!
    let ref = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(conversation.getMessages())
        
        textField.delegate = self
//        if(sender == me){
//            for i in 0...10{
//                let label = UILabel(frame: CGRect(x: Int(self.view.frame.width/2), y: 100*i+100, width: 100, height: 50))
//                label.text = "Hello World"//messages[messages.length-1]
//                label.layer.cornerRadius = 10
//                conversationScrollView.addSubview(label)
//            }
//        }else{
            for i in 0...10{
                let label = UILabel(frame: CGRect(x: 30, y:100*i, width: 100, height: 50))
                label.text = "Hello World"//messages[messages.length-1]
                label.backgroundColor = UIColor.white
                label.layer.masksToBounds = true
                label.layer.cornerRadius = 15
                conversationScrollView.addSubview(label)
            }
        //}
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        print(conversation.getCurrentUser())
        
        ref.child("Conversations/\(conversation.getConversationToken())/Jenny").observe(FIRDataEventType.value, with: { (snapshot) in
            let pulledMessages = snapshot.value as! [[String:String]]
            for m in pulledMessages {
                print(m)
            }
        })
        
        // Do any additional setup after loading the view.
        print(conversation.getRecipients())
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        print("Pressed Send")
        conversation.sendMessage(message: textField.text!)
//        for user in conversation.getRecipients() {
//            ref.child("Conversations/\(conversation.getConversationToken())/\(user)").updateChildValues([conversation.getCurrentUser():textField.text!])
//        }
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
