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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPaymentToServer(_ sender: AnyObject) {
        // check server if payment already exists
        
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
