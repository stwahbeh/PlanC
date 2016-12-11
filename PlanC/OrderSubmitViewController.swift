//
//  OrderSubmitViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase

class OrderSubmitViewController: UIViewController {
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderOwnerLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var condoms = Inventory(inventory: 0, price: 0.0)
    
    var email = ""
    var address = ""
    var creditCard = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user == nil {
                // 3
                self.performSegue(withIdentifier: "submitToLogInSegue", sender: self)
            }

        }
        
        let ref = self.appDelegate.getDatabaseReference()
        
        
        ref.observe(.value, with: { snapshot in
            let value = snapshot.value as! NSDictionary
            // print("value: \(value)")
            if let inventory = value["Inventory"] as? NSDictionary {
                let product = inventory["Condoms"] as! [String: Int]
                self.condoms.inventory = product["Qty"]!
                self.condoms.price = Double(product["Price"]!)
                
            }
        })


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToProfile(_ sender: AnyObject) {
        // show up "Proceed? Yes/No"
        
        // add function send sms
        sendSMS()
        
        performSegue(withIdentifier: "submitToProfileSegue", sender: nil)
        
    }

    // send SMS to Simba's Phone
    func sendSMS() {
        
    }
    
    
    @IBAction func returnToPreviousScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "submitToMapSegue", sender: nil)
    }
    
    @IBAction func submitOrder(_ sender: UIButton) {
        
        let ref = self.appDelegate.getDatabaseReference()
        let condomRef = ref.child("Inventory/Condoms")
        self.condoms.inventory -= 3
        condomRef.setValue(["Qty": self.condoms.inventory, "Price": 10] )
    
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
