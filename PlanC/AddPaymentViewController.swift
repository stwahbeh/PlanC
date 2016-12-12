//
//  AddPaymentViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase

class AddPaymentViewController: UIViewController {
    @IBOutlet weak var paymentNameLabel: UITextField!
    @IBOutlet weak var ccNumberLabel: UITextField!
    @IBOutlet weak var ccExpirationLabel: UITextField!
    @IBOutlet weak var ccSecurityCodeLabel: UITextField!
    @IBOutlet weak var ccNameLabel: UITextField!
    
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
                self.performSegue(withIdentifier: "paymentToLogInSegue", sender: self)
            }
        }
        
        // Error checking to see if data passed through from previous screens
        
        if (email == nil || email == "") {
            email = "could not get email"
        }
        
        if (address == nil) {
            address = "could not get address"
        }
        
        if (creditCard == nil) {
            creditCard = "could not get credit card"
        }

        // Do any additional setup after loading the view.
        print(self.email + " fuck")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPaymentToServer(_ sender: AnyObject) {
        // check server if payment already exists
        
        let paymentName = self.paymentNameLabel.text!
        let cardNumber = self.ccNumberLabel.text!
        let expirationDate = self.ccExpirationLabel.text!
        let securityCode = self.ccSecurityCodeLabel.text!
        let nameOnCard = self.ccNameLabel.text!
        let payment = Payment(paymentName: paymentName, cardNumber: cardNumber, expirationDate: expirationDate, securityCode: securityCode, nameOnCard: nameOnCard)
        
        let ref = appDelegate.getDatabaseReference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        let usersRef = ref.child("Users")
        let userRef = usersRef.child(byAppendingPath: userID!)
        
        userRef.setValue(["Address": self.address, "creditCard": payment.toAnyObject(), "email": self.email])
        
        // dismiss to profile
        backToProfile(self)
    }
    
    @IBAction func backToProfile(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "paymentToProfileSegue"){
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
