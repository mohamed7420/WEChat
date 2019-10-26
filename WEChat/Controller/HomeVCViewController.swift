//
//  HomeVCViewController.swift
//  WEChat
//
//  Created by Mohamed on 10/25/19.
//  Copyright © 2019 Mohamed74. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class HomeVCViewController: UIViewController , UITextFieldDelegate{
    
    var rooms:[RoomName] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var roomTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomTF.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        listenToData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil{
            
            self.presentToLoginScreen()
        }
        
    }

    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do{
        
        try Auth.auth().signOut()
            
        }catch{
            
            print("error")
        }
        
      presentToLoginScreen()
        
    }
    
    func presentToLoginScreen(){
        
        let VC = storyboard?.instantiateViewController(identifier: "loginScreen") as! ViewController
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
    }

    @IBAction func btn_newRoom(_ sender: UIButton) {
        
        
        createRoom()
        
    }
    
    
    func createRoom(){
        
        guard let roomText = roomTF.text else {return}
        
        let reference = Database.database().reference()
        
        let rooms = reference.child("Rooms").childByAutoId()
        
        
        let dataDictionary: [String:Any] = ["roomName": roomText]
        
        rooms.setValue(dataDictionary) { (error, refernce) in
            
            if error != nil{
                
                self.clearText()
                
            }else{
                
                print("Room created..")
                self.clearText()
            }
        }
    }
    
    
    func clearText(){
        
        roomTF.text = ""
    }
    
    func listenToData(){
        
        let reference = Database.database().reference()
        
        reference.child("Rooms").observe(.childAdded){(snapShot) in
            
            if let dataArray = snapShot.value as? [String:Any]{
                
                if let roomName = dataArray["roomName"] as? String {
                    
                    //print(roomName)
                    let room = RoomName(roomID: snapShot.key , roomName: roomName)
                    
                    self.rooms.append(room)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}


extension HomeVCViewController : UITableViewDelegate , UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath)
        
        cell.textLabel?.text = rooms[indexPath.row].roomName
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRoom = rooms[indexPath.row]
        
        let chatViewController = self.storyboard?.instantiateViewController(identifier: "chatViewController") as! ChatViewController
        
        chatViewController.room = selectedRoom
            
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
           self.view.endEditing(true)
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           
           textField.resignFirstResponder()
           
           return true
       }
}
