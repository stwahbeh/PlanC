//
//  SignUpViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var checkLabel: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.performSegue(withIdentifier: "signUpToProfileSegue", sender: self)
                // Do any additional setup after loading the view.
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func signUp(_ sender: UIButton) {
    
        let email = usernameLabel.text!
        let password = passwordLabel.text!
        let check = checkLabel.text!
        let username = nameLabel.text!
        
        // let name = nameLabel.text!
        
        print(username)
        print(password)
        
        // Password has to be at least 6 char long
        if password == check {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                FIRAuth.auth()!.signIn(withEmail: email, password: password)
                
                 //Testing the database setup
                let ref = self.appDelegate.getDatabaseReference()
                let user = User(email: email, address: "", creditCard: "")
                let users = ref.child("Users")
                let userRef = users.child(username)
                // ref.child("testing").setValue(["address": "", "creditCard": ""])
                // Saves to Firebase
                userRef.setValue(user.toAnyObject())
                print("benjamin likes long bananas")
                print(userRef)
                
            } else {
                self.warningLabel.text = "\(error)"
                print(error)
            }
        }
        } else {
            self.warningLabel.text = "passwords don't match"
        }
    }
    // http://stackoverflow.com/questions/27998409/email-phone-validation-in-swift
    
    @IBAction func backToLogIn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
