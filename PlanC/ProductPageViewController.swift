//
//  ProductPageViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase

class ProductPageViewController: UIViewController {

    @IBOutlet weak var QtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    
    let imageIcon = #imageLiteral(resourceName: "condoms")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var condoms = Inventory(inventory: 0, price: 0.0)
    var hasEnough = false
    
    var email: String!
    var address: String!
    var creditCard: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buyButton.layer.cornerRadius = 4
        goBackButton.layer.cornerRadius = 4
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user == nil {
                // 3
                self.performSegue(withIdentifier: "productToLogInSegue", sender: self)
            }
        }
        
        productImage.image = imageIcon
        
        let ref = self.appDelegate.getDatabaseReference()
        
        
        ref.observe(.value, with: { snapshot in
            let value = snapshot.value as! NSDictionary
            if let inventory = value["Inventory"] as? NSDictionary {
                let product = inventory["Condoms"] as! [String: Int]
                self.condoms.inventory = product["Qty"]!
                self.condoms.price = Double(product["Price"]!)
                
                if (self.condoms.inventory >= 3){
                    self.hasEnough = true
                }
                
                self.priceLabel.text = "$\(product["Price"]!).00"
                
                
            }

        })


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToMap(_ sender: AnyObject) {
        // check if product is selected
        // check if qty is supported in inventory
        if self.hasEnough == true {
            performSegue(withIdentifier: "productToMapSegue", sender: self)
        } else {
            warningLabel.text = "Cannot perform order at current time. Not enough inventory"
        }
    }
	
    @IBAction func returnToPreviousScreen(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        // performSegue(withIdentifier: "productToProfileSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "productToMapSegue"){
            let controller = segue.destination as! MapViewController

//            controller.email = email
            // print(self.address)
            controller.address = self.address
//            controller.creditCard = creditCard
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
