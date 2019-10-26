//
//  ChatViewController.swift
//  WEChat
//
//  Created by Mohamed on 10/26/19.
//  Copyright © 2019 Mohamed74. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController  , UITextFieldDelegate{

    @IBOutlet weak var messageTF: UITextField!
    
    var room:RoomName?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Chat Message"
        messageTF.delegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
           self.view.endEditing(true)
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              
              textField.resignFirstResponder()
              
              return true
          }
    
    
    @IBAction func btn_Send(_ sender: UIButton) {

        
        let dataRef = Database.database().reference()
        
        let user = dataRef.child("users").child(((Auth.auth().currentUser?.uid)!))
        
        user.child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let username = snapshot.value as? String {
                if let roomId = self.room?.roomID{
                   
                    let room = dataRef.child("Rooms").child(roomId)
                    
                    room.child("messages")
                }
            }
            
        })
        
    }
    
}
