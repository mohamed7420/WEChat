//
//  ViewController.swift
//  WEChat
//
//  Created by Mohamed on 10/24/19.
//  Copyright © 2019 Mohamed74. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController , UICollectionViewDelegate {

    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.delegate = self
        collectionview.dataSource = self

       // accessFirebase()
        
    }
    
    
    func accessFirebase(){
        
        let reference = Database.database().reference().child("Data")
        reference.setValue("Hello WEChat")
    }


}



extension ViewController: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! CustomCell
        
        if indexPath.row == 0 {
            
            cell.usernameTF.isHidden = true
            cell.signinTF.setTitle("Login", for: .normal)
            cell.signupTF.setTitle("Signup", for: .normal)
            cell.signupTF.addTarget(self, action: #selector(goToSignup), for: .touchUpInside)
            cell.signinTF.addTarget(self, action: #selector(handleSignIn(_:)), for: .touchUpInside)
            
        }else if indexPath.row == 1{
            
            cell.usernameTF.isHidden = false
            cell.signinTF.setTitle("Signup", for: .normal)
            cell.signinTF.setTitle("Signin", for: .normal)
            cell.signinTF.addTarget(self, action: #selector(goToSignin(_:)), for: .touchUpInside)
            cell.signupTF.addTarget(self, action: #selector(createUserAuthentication(_:)), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
    
    //MARK:- Handle Buttons Functions
    
    @objc func goToSignup(_ sender:UIButton){
        
        let indexPath = IndexPath(item: 1, section: 0)
        
        self.collectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func goToSignin(_ sender:UIButton){
          
          let indexPath = IndexPath(item: 0, section: 0)
          
          self.collectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
      }
    
    @objc func createUserAuthentication(_ sender:UIButton){
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        let cell = self.collectionview.cellForItem(at: indexPath) as! CustomCell
        
        guard let username = cell.usernameTF.text else {return}
        guard let email = cell.emailTF.text else {return}
        guard let password = cell.passwordTF.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (userInfo, error) in
            
            if error != nil && userInfo == nil{
                
                //There is error while creating new user
                
                print("error while creating new user \(error?.localizedDescription ?? "error")")
                cleanText()
            }else {
                
                //Successfullt created new user
                
                guard let username = cell.usernameTF.text  , let userID = userInfo?.user.uid else {return}
                
                let reference = Database.database().reference()
                let user = reference.child("users").child((userID))
                let dataArray:[String:Any] = ["username" : username]
                user.setValue(dataArray)
                
                print("user created successfully")
                cleanText()
                self.dismiss(animated: true, completion: nil)
            }
            
            
        }
        
        func cleanText(){
            
            let indexPath = IndexPath(row: 1, section: 0)
            let cell = collectionview.cellForItem(at: indexPath) as! CustomCell
            cell.usernameTF.text = ""
            cell.emailTF.text = ""
            cell.passwordTF.text = ""
        }
        
        
    }
    
    @objc func handleSignIn(_ sender: UIButton){
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = collectionview.cellForItem(at: indexPath) as! CustomCell
        
        guard let email = cell.emailTF.text else {return}
        guard let password = cell.passwordTF.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                
                self.dismiss(animated: true, completion: nil)
                
            }else {
                print("error in logged in")
            }
            
        }
        
        
    }
    
}

