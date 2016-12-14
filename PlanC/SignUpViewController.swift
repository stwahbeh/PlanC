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
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBOutlet weak var confirmLabel: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    
    var email: String!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 4
        goBackButton.layer.cornerRadius = 4
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                self.performSegue(withIdentifier: "signUpToProfileSegue", sender: self)
                // Do any additional setup after loading the view.
            }
        }
        
        // Do any additional setup after loading the view.
        self.emailLabel.keyboardType = UIKeyboardType.emailAddress
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        let email = emailLabel.text!
        let password = passwordLabel.text!
        let confirm = confirmLabel.text!

        //let charset = NSCharacterSet(charactersInString: "<.@>()[]{}:';,/?|\"\\=+")
        // let name = nameLabel.text!
        
        var newEmail = email.replacingOccurrences(of: ".", with: ",")
        newEmail = newEmail.replacingOccurrences(of: "[", with: ",")
        newEmail = newEmail.replacingOccurrences(of: "]", with: ",")
        newEmail = newEmail.replacingOccurrences(of: "#", with: ",")
        newEmail = newEmail.replacingOccurrences(of: "$", with: ",")
        
        // Password has to be at least 6 char long

                if password == confirm {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                        
                        if error == nil {
                            FIRAuth.auth()!.signIn(withEmail: email, password: password)
                            
                            //Testing the database setup
                            let ref = self.appDelegate.getDatabaseReference()
                            let user = User(email: email, address: "", creditCard: "", userlevel: 1)
                            let users = ref.child("Users")
                            let userRef = users.child(newEmail)
                            // ref.child("testing").setValue(["address": "", "creditCard": ""])
                            // Saves to Firebase
                            userRef.setValue(user.toAnyObject())
                            // print("benjamin likes long bananas")
                            // print(userRef)
                            
                        } else {
                            if (self.passwordLabel.text == "" && self.emailLabel.text != "") {
                                self.warningLabel.text = "Missing password"
                            } else {
                                self.warningLabel.text = "\(error!.localizedDescription)"
                            }
                        }
                    }
                } else {
                    self.warningLabel.text = "Passwords don't match"
                }
    }
    
    @IBAction func backToLogIn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "logInToProfileSegue") {
            email = emailLabel.text!
            let controller = segue.destination as! ProfileViewController
            controller.email = email
            print(controller.email)
        }
        
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
