//
//  AddAddressViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase

class AddAddressViewController: UIViewController {
    @IBOutlet weak var addressNameLabel: UITextField!
    @IBOutlet weak var addressOneLabel: UITextField!
    
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var zipCodeLabel: UITextField!
    
    var email: String!
    var address: String!
    var creditCard: String!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user == nil {
                // 3
                self.performSegue(withIdentifier: "addressToLogInSegue", sender: self)
            }
        }

        // Do any additional setup after loading the view.
        
        print(self.email + " fuck")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addAddressToServer(_ sender: AnyObject) {
        // check if address is already in server
        let addressName = addressNameLabel.text!
        let addressOne = addressOneLabel.text!
        let state = stateLabel.text!
        let city = cityLabel.text!
        let zipcode = zipCodeLabel.text!
        
        let lines : [String] = [addressName, addressOne, city, state, zipcode]
        var address = addressName
        for i in 1...lines.count - 1 {
            address = address + "\n" + lines[i]
        }
        print("Address: \(address)")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ref = appDelegate.getDatabaseReference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        let usersRef = ref.child("Users")
        let userRef = usersRef.child(byAppendingPath: userID!)
        print("email: \(self.email)")
        userRef.setValue(["Address": address, "creditCard": self.creditCard, "email": self.email])
        
        // dismiss to profile
        backToProfile(self)
    }
    
    @IBAction func backToProfile(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addressToProfileSegue"){
            let controller = segue.destination as! ProfileViewController
            controller.email = email
            controller.address = address
            controller.creditCard = creditCard
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
