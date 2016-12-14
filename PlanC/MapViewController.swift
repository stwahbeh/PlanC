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
    
    @IBOutlet weak var selectedAddress: UILabel!
    @IBOutlet weak var toOrderSubmitButton: UIButton!
    var address: String!
    var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var goBackButton: UIButton!
    
    // example: https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyDUP3C-CgRA_xy1iVP-B6vpnMnnqiltyrI
    let baseURL = "https://maps.googleapis.com/maps/api/geocode/json?address="
    // address is data from firebase replacing spaces with "+"
    let apiKey = "AIzaSyDUP3C-CgRA_xy1iVP-B6vpnMnnqiltyrI"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toOrderSubmitButton.layer.cornerRadius = 4
        goBackButton.layer.cornerRadius = 4
        
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
        
        // calls google maps api for geocoding data
        requestData()
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .topMargin, relatedBy: .equal, toItem: selectedAddress, attribute: .bottomMargin, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .bottomMargin, relatedBy: .equal, toItem: toOrderSubmitButton, attribute: .topMargin, multiplier: 1, constant: -30))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .leadingMargin, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1, constant: 8))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .trailingMargin, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: 8))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
    }
	
    override func loadView() {
        super.loadView()
        mapView = GMSMapView.map(withFrame: .init(x: 16, y: 125, width: 343, height: 371), camera: GMSCameraPosition.camera(withLatitude: 47.6549516,
                                                                                                                            longitude: -122.3089823,
                                                                                                                            zoom: 12))
    }
    
    // Creates new marker at long press location
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let pressedLocation = GMSMarker(position: coordinate)
        pressedLocation.title = "New Location"
        pressedLocation.snippet = "\(coordinate.latitude), \(coordinate.longitude)"
        pressedLocation.map = mapView
    }
    
    // Clears all markers when the user taps on somewhere besides a marker
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
    }
    
    // Changes selected address text upon tapping a marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        selectedAddress.text = "Address Selected: \n" + marker.title!
        return false
    }
    
    // Geocoding request. Creates marker asynchronously when it receives the response data.
    func requestData() -> Void {
        print(address)
        let newAddress = address.replacingOccurrences(of: " ", with: "+")
        let urlPath = URL(string: baseURL + newAddress + "&key=" + apiKey)!
        let urlRequest = URLRequest(url: urlPath)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! NSDictionary
                    let results = json["results"] as! NSArray
                    if (results.count > 0) {
                        let details = results[0] as! NSDictionary
                        let geometry = details["geometry"] as! NSDictionary
                        let location = geometry["location"] as! NSDictionary
                        let lat = location["lat"] as! CLLocationDegrees
                        let lng = location["lng"] as! CLLocationDegrees
                        
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        
                        // To access the main thread so the marker can be created asynchronously
                        DispatchQueue.main.async {
                            [weak self] in
                            // move the camera to default address location
                            self?.mapView.animate(toLocation: coordinate)
                            
                            // Add marker for default address
                            let defaultAddress = GMSMarker(position: coordinate)
                            defaultAddress.title = "Default Address"
                            defaultAddress.snippet = "\(coordinate.latitude), \(coordinate.longitude)"
                            defaultAddress.map = self?.mapView
                            self?.select(marker: defaultAddress)
                            return
                        }
                    }
                } catch {
                    print("error: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    // Delegate for updating user location. Creates a marker at the user's location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        // Add marker for current location
        let lat = location?.coordinate.latitude
        let lng = location?.coordinate.longitude
        
        let currentPosition = GMSMarker(position: .init(latitude: (lat)!, longitude: (lng)!))
        currentPosition.title = "Current Location"
        currentPosition.snippet = "\(lat!), \(lng!)"
        currentPosition.map = mapView
        if (mapView.selectedMarker == nil) {
            select(marker: currentPosition)
        }
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func select(marker: GMSMarker) {
        mapView.selectedMarker = marker
        selectedAddress.text = "Address Selected: \n" + marker.title!
    }
    
    // Segue to Order Submit page
    @IBAction func goToSubmit(_ sender: AnyObject) {
        performSegue(withIdentifier: "mapToSubmitSegue", sender: self)
    }
	
    // Segue back
    @IBAction func returnToPreviousScreen(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        // performSegue(withIdentifier: "mapToProductSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If to submit page. Passes position.
        if (segue.identifier == "mapToSubmitSegue") {
            let selected = mapView.selectedMarker
            let controller = segue.destination as! OrderSubmitViewController
            controller.location = selected?.position
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
