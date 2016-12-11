//
//  MapViewController.swift
//  PlanC
//
//  Created by iGuest on 11/29/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    @IBOutlet weak var containedMap: UIView!
    var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    // https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyDUP3C-CgRA_xy1iVP-B6vpnMnnqiltyrI
    // let baseURL = "https://maps.googleapis.com/maps/api/geocode/json?address="
    // address is data from firebase replacing spaces with "+"
    // let apiKey = "AIzaSyDUP3C-CgRA_xy1iVP-B6vpnMnnqiltyrI"
    // requestURL = "\(baseURL)\(address)key=\(apiKey)"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user == nil {
                // 3
                self.performSegue(withIdentifier: "mapToLogInSegue", sender: self)
            }
        }

        // Do any additional setup after loading the view.
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        mapView.center = self.view.center
        self.view.addSubview(mapView)
    }
	
    override func loadView() {
        super.loadView()
        mapView = GMSMapView.map(withFrame: containedMap.frame, camera: GMSCameraPosition.camera(withLatitude: 1.285,
                                                                                                                           longitude: 103.848,
                                                                                                                           zoom: 12))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.setNeedsLayout()
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom:14)
        mapView.animate(to: camera)
        
        let currentPosition = GMSMarker(position: .init(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!))
        currentPosition.map = mapView
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func goToSubmit(_ sender: AnyObject) {
        // check address
        
        performSegue(withIdentifier: "mapToSubmitSegue", sender: self)
    }
	
    @IBAction func returnToPreviousScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "mapToProductSegue", sender: nil)
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
