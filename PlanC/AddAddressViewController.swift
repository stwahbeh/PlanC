//
//  AddAddressViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class AddAddressViewController: UIViewController {
    @IBOutlet weak var addressNameLabel: UITextField!
    @IBOutlet weak var addressOneLabel: UITextField!
    
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var zipCodeLabel: UITextField!
    
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    
    var email: String!
    var address: String!
    var creditCard: String!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeAddressButton.layer.cornerRadius = 4
        goBackButton.layer.cornerRadius = 4
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user == nil {
                // 3
                self.performSegue(withIdentifier: "addressToLogInSegue", sender: self)
            }
            if (self.creditCard == nil) {
                self.creditCard = "credit card was not found"
            }
            if (self.email == nil || self.email == "") {
                self.email = "email was not found"
            }
        }

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAddressToServer(_ sender: AnyObject) {
        // check if address is already in server
        let addressName = addressNameLabel.text!
        let addressOne = addressOneLabel.text!
        let city = cityLabel.text!
        let state = stateLabel.text!
        let zipcode = zipCodeLabel.text!
        
        // Regex checks
        
        // Zipcode - (zipcode regex not being detected in quotes)
        
//        let zipcodeRegex = "replaceWithRegex"
//        let test = NSPredicate(format: "", zipcodeRegex)
//        print("zipcode test: \(test.evaluate(with: zipcode))")
        
        
        let ref = appDelegate.getDatabaseReference()
        let address = Address(addressName: addressName, address: addressOne, city: city, state: state, zipcode: zipcode)
        
        print("address: \(address.toAnyObject())")
        print("creditCard: \(self.creditCard)")
        print("email: \(self.email)")
        
        let newEmail = email.replacingOccurrences(of: ".", with: ",")
        ref.child("Users/\(newEmail)/address").setValue(address.toAnyObject())
        
        
        // dismiss to profile
        backToProfile(self)
    }
    
    @IBAction func backToProfile(_ sender: AnyObject) {
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
