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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func signUp(_ sender: UIButton) {
    
//        let username = usernameLabel.text!
//        let password = passwordLabel.text!
//        let name = nameLabel.text!
//        
//        FIRAuth.auth()!.createUser(withEmail: username, password: password, completion: <#T##FIRAuthResultCallback?##FIRAuthResultCallback?##(FIRUser?, Error?) -> Void#>)
        let ref = appDelegate.getDatabaseReference()
        let user = User(email: usernameLabel.text!, password: passwordLabel.text!, address: "", creditCard: "")
        let userRef = ref.child("data")
        //ref.child("users").setValue(["email": email, "password": password])
        // Saves to Firebase
        userRef.setValue(user.toAnyObject())
    
    }
    
    
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
