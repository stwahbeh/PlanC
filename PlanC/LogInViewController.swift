//
//  LogInViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    var condoms = Inventory(inventory: 0, price: 0.0)
    var email: String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logInButton.layer.cornerRadius = 4
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            
            if user != nil {
                
                self.performSegue(withIdentifier: "logInToProfileSegue", sender: self)
            }
        }
        
        // Testing data retrieval
        let ref = self.appDelegate.getDatabaseReference()
//        ref.observe(.value, with: { snapshot in
//            if (snapshot.exists()) {
//                print(snapshot.value)
//                let inventory = snapshot.childSnapshot(forPath: "Inventory").value as? [[String: Any]]
//                // Nil as of now
//                print("Inventory: \(inventory)")
//            }
//        })
    
        ref.observe(.value, with: { snapshot in
            let value = snapshot.value as! NSDictionary
            // print("value: \(value)")
            if let inventory = value["Inventory"] as? NSDictionary {
                let product = inventory["Condoms"] as! [String: Int]
                self.condoms.inventory = product["Qty"]!
                self.condoms.price = Double(product["Price"]!)
                // print("qty = \(self.condoms.getInventory()), price = \(self.condoms.getPrice())")
            }

        })
//        ref.child("Users").observe(.value, with: { (snapshot) in
//            
//            print (snapshot.value as! [String:AnyObject]!)
//
//        })
        self.emailLabel.keyboardType = UIKeyboardType.emailAddress
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func signIn () {
        //FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            // ...
        //FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: <#T##FIRAuthResultCallback?##FIRAuthResultCallback?##(FIRUser?, Error?) -> Void#>)
    }
        
	@IBAction func logIn(_ sender: AnyObject) {
        // check if username exists
        
        // check if password is correct for username
        FIRAuth.auth()!.signIn(withEmail: emailLabel.text!, password: passwordLabel.text!) { user, error in
            if user == nil {
                if (self.passwordLabel.text == "" && self.emailLabel.text != "") {
                    self.warningLabel.text = "Missing password"
                } else {
                    self.warningLabel.text = "\(error!.localizedDescription)"
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "logInToProfileSegue") {
            email = emailLabel.text!
            let controller = segue.destination as! ProfileViewController
            controller.email = email
        }
        
    }

    // http://stackoverflow.com/questions/27998409/email-phone-validation-in-swift
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
