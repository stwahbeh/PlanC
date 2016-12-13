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
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var addressShowLabel: UILabel!
    @IBOutlet weak var paymentShowLabel: UILabel!
    
    var email: String!
    var address: String!
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
                ref.child("Users").child(newEmail).child("address").observe(.value, with: { snapshot in
                    print("snapshot val: \(snapshot.value)")
                    if let _ = snapshot.value as? NSDictionary {
                        let addressRef = snapshot.value as! NSDictionary
                        
                        print("address accessed: \(addressRef)")
                        let addressName = addressRef["Name"]
                        let address = addressRef["Address"]
                        let city = addressRef["City"]
                        let state = addressRef["State"]
                        let zipcode = addressRef["Zipcode"]
                        
                        let userAddress = Address(addressName: addressName as! String, address: address as! String, city: city as! String, state: state as! String, zipcode: zipcode as! String)
                        self.addressShowLabel.text = userAddress.getAddressName()
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
            controller.address = address
            controller.creditCard = creditCard
        }
        else if (segue.identifier == "profileToPaymentSegue"){
            let controller = segue.destination as! AddPaymentViewController
            controller.email = email
            controller.address = address
            controller.creditCard = creditCard
        }
        else if (segue.identifier == "profileToProductSegue"){
            let controller = segue.destination as! ProductPageViewController
            controller.email = email
            controller.address = address
            controller.creditCard = creditCard
            
        } else {
            
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
