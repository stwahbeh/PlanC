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

class OrderSubmitViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var buyerEmail: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var deliveryAddressLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var productBoughtLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var mapView: GMSMapView!
    var condoms = Inventory(inventory: 0, price: 0.0)
    var email: String!
    var address: String!
    var location: CLLocationCoordinate2D!
    var upperRight: CLLocationCoordinate2D!
    var lowerLeft: CLLocationCoordinate2D!
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
        let date = NSDate()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        upperRight = CLLocationCoordinate2D.init(latitude: location.latitude + (CLLocationDegrees.init(0.001)), longitude: location.longitude - (CLLocationDegrees.init(0.004)))
        lowerLeft = CLLocationCoordinate2D.init(latitude: location.latitude - (CLLocationDegrees.init(0.001)), longitude: location.longitude + (CLLocationDegrees.init(0.004)))
        
        let delivLocation = GMSMarker(position: location)
        delivLocation.title = "Selected Delivery Location"
        delivLocation.snippet = "\(location.latitude), \(location.longitude)"
        delivLocation.map = mapView
        mapView.selectedMarker = delivLocation
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .topMargin, relatedBy: .equal, toItem: deliveryAddressLabel, attribute: .bottomMargin, multiplier: 1, constant: 16))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .bottomMargin, relatedBy: .equal, toItem: productBoughtLabel, attribute: .topMargin, multiplier: 1, constant: -22))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .leadingMargin, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1, constant: 8))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: 8))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
        self.email = FIRAuth.auth()?.currentUser?.email

        buyerEmail.text! = "Email: \(email!)"
        orderDateLabel.text! = "Order Date: \(date)"
        
        
        
    }
    
    override func loadView() {
        super.loadView()
        mapView = GMSMapView.map(withFrame: .init(x: 33, y: 220, width: 309, height: 188), camera: GMSCameraPosition.camera(withTarget: location, zoom: 12))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        mapView.animate(toLocation: location)
    }
    
    
    @IBAction func returnToPreviousScreen(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        // performSegue(withIdentifier: "submitToMapSegue", sender: nil)
    }
    
    @IBAction func submitOrder(_ sender: UIButton) {
        let date = NSDate()
        let ref = self.appDelegate.getDatabaseReference()
        let condomRef = ref.child("Inventory/Condoms")
        self.email = FIRAuth.auth()?.currentUser?.email
        self.condoms.inventory -= 3
        condomRef.setValue(["Qty": self.condoms.inventory, "Price": 10] )
        let order = Order(address: "\(location!.latitude), \(location!.longitude)", cost: "10", email: email, qty: "1")
        let orders = ref.child("Order")
        var newEmail = self.email.replacingOccurrences(of: ".", with: ",")
        newEmail = newEmail.replacingOccurrences(of: "[", with: ",")
        newEmail = newEmail.replacingOccurrences(of: "]", with: ",")
        newEmail = newEmail.replacingOccurrences(of: "#", with: ",")
        newEmail = newEmail.replacingOccurrences(of: "$", with: ",")
        let orderRef = orders.child("\(newEmail) \(date)")
        orderRef.setValue(order.toAnyObject())
        
        let settingsController = UIAlertController(title: "Thank you for your order!", message: "We will deliver it in 10 seconds from now", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            self.performSegue(withIdentifier: "unwindToProfileSegue", sender: self)
        }
        
        settingsController.addAction(defaultAction)
        present(settingsController, animated: true, completion: nil)
        
        
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
