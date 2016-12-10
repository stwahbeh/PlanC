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

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    var condoms = Inventory(inventory: 0, price: 0.0, key: "")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        // Prints Snapshots correctly, but data is iaccessible
        ref.observe(.value, with: { snapshot in
            let value = snapshot.value as! NSDictionary
            print("value: \(value)")
            if let invntry = value["Inventory"] as? NSDictionary {
                let product = invntry["Condoms"] as! [String: Int]
                self.condoms.inventory = product["Qty"]!
                self.condoms.price = Double(product["Price"]!)
                print("qty = \(self.condoms.getInventory()), price = \(self.condoms.getPrice())")
            }
            for item in snapshot.children {
                print(item)
            }
        })
        
        
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
        FIRAuth.auth()!.signIn(withEmail: usernameLabel.text!, password: passwordLabel.text!) { user, error in
            if user == nil {
                self.warningLabel.text = "\(error)"
                print(error)
            }
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
