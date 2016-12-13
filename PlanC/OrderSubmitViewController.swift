//
//  OrderSubmitViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import MapKit
import GoogleMaps

class OrderSubmitViewController: UIViewController {
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderOwnerLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var mapView: GMSMapView!
    var condoms = Inventory(inventory: 0, price: 0.0)
    var email: String!
    var address: String!
    var location: CLLocationCoordinate2D!
    var creditCard: String!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 4
        goBackButton.layer.cornerRadius = 4
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user == nil {
                // 3
                self.performSegue(withIdentifier: "submitToLogInSegue", sender: self)
            }

        }
        
        print(location)
        
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
        let delivLocation = GMSMarker(position: location)
        delivLocation.map = mapView
        self.view.addSubview(mapView)
    }
    
    override func loadView() {
        super.loadView()
        mapView = GMSMapView.map(withFrame: .init(x: 33, y: 220, width: 309, height: 188), camera: GMSCameraPosition.camera(withTarget: location, zoom: 14))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        mapView.animate(toLocation: location)
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
        let date = NSDate()
        let ref = self.appDelegate.getDatabaseReference()
        let condomRef = ref.child("Inventory/Condoms")
        self.email = FIRAuth.auth()?.currentUser?.email
        self.condoms.inventory -= 3
        condomRef.setValue(["Qty": self.condoms.inventory, "Price": 10] )
        let order = Order(address: "\(date)", cost: "10", email: email, qty: "1")
        let orders = ref.child("Order")
        let orderRef = orders.child("\(email) \(date)")
        orderRef.setValue(order.toAnyObject())
        
        
        
        
        
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
