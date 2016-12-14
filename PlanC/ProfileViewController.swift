//
//  ProfileViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var adminButton: UIButton!
    
    var email: String!
    var userAddress: Address? = nil
    var creditCard: String!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productButton.layer.cornerRadius = 4
        logOutButton.layer.cornerRadius = 4
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // error
            if user == nil {
                // 3
                self.performSegue(withIdentifier: "profileToLogInSegue", sender: self)
            } else {
                
                let ref = self.appDelegate.getDatabaseReference()
                self.email = FIRAuth.auth()?.currentUser?.email
                let newEmail = self.email.replacingOccurrences(of: ".", with: ",")
                print("email: \(newEmail)")
                
                // load address
                ref.child("Users").child(newEmail).child("address").observe(.value, with: { snapshot in
                    if let _ = snapshot.value as? NSDictionary {
                        let addressRef = snapshot.value as! NSDictionary
                        let addressName = addressRef["Name"]
                        let address = addressRef["Address"]
                        let city = addressRef["City"]
                        let state = addressRef["State"]
                        let zipcode = addressRef["Zipcode"]
                        
                        self.userAddress = Address(addressName: addressName as! String, address: address as! String, city: city as! String, state: state as! String, zipcode: zipcode as! String)
                        self.addressLabel.text = self.userAddress?.toString
                    }
                })
                
                // load payment
                
                ref.child("Users").child(newEmail).child("creditCard").observe(.value, with: { snapshot in
                    if let _ = snapshot.value as? NSDictionary {
                        let paymentRef = snapshot.value as! NSDictionary
                        let paymentName = paymentRef["Name"]
                        let nameOnCard = paymentRef["Name on Card"]
                        let cardNumber = paymentRef["Number"]
                        let expirationDate = paymentRef["Expiration"]
                        let securityCode = paymentRef["Security Code"]
                        
                        var userPayment = Payment(paymentName: paymentName as! String, cardNumber: cardNumber as! String, expirationDate: expirationDate as! String, securityCode: securityCode as! String, nameOnCard: nameOnCard as! String)
                        userPayment.cardNumber = "XXXX-XXXX-XXXX-" + userPayment.cardNumber.substring(from:userPayment.cardNumber.index(userPayment.cardNumber.endIndex, offsetBy: -4))
                        self.paymentLabel.text = userPayment.toString
                    }
                })
                
                ref.child("Users").child(newEmail).child("userlevel").observe(.value, with: { snapshot in
                    if let userLevel = snapshot.value as? Int {
                        self.adminButton.isHidden = userLevel <= 9000
                    }
                })
            }
        }
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToProduct(_ sender: AnyObject) {
        // check if there's at least 1 address and is selected
        
        // check if there's at least 1 payment and is selected
        
        performSegue(withIdentifier: "profileToProductSegue", sender: self)
    }
    
    // log out user
    @IBAction func logOut(_ sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            performSegue(withIdentifier: "profileToLogInSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileToAddressSegue") {
            let controller = segue.destination as! AddAddressViewController
            controller.email = email
            controller.address = userAddress?.getAddress()
            controller.creditCard = creditCard
        }
        else if (segue.identifier == "profileToPaymentSegue"){
            let controller = segue.destination as! AddPaymentViewController
            controller.email = email
            controller.address = userAddress?.getAddress()
            controller.creditCard = creditCard
        }
        else if (segue.identifier == "profileToProductSegue"){
            let controller = segue.destination as! ProductPageViewController
            controller.email = email
            controller.address = userAddress?.getAddress()
            controller.creditCard = creditCard
            
        } else {
            
        }
    }
    
    @IBAction func backFromSubmit(segue: UIStoryboardSegue) {
        print("and we are back")
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
