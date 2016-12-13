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
    var address: String! = "NE+45TH+ST+and+15TH+AVE+NE"
    var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let geocoder = GMSGeocoder()
    
    // example: https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyDUP3C-CgRA_xy1iVP-B6vpnMnnqiltyrI
    let baseURL = "https://maps.googleapis.com/maps/api/geocode/json?address="
    // address is data from firebase replacing spaces with "+"
    let apiKey = "AIzaSyDUP3C-CgRA_xy1iVP-B6vpnMnnqiltyrI"
    
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
        
//        requestData()
        getMarkerAddress()
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
//        mapView.center = self.view.center
        self.view.addSubview(mapView)
    }
	
    override func loadView() {
        super.loadView()
        mapView = GMSMapView.map(withFrame: .init(x: 67, y: 125, width: 240, height: 342), camera: GMSCameraPosition.camera(withLatitude: 47.6549516,
                                                                                                                            longitude: -122.3089823,
                                                                                                                            zoom: 12))
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let pressedLocation = GMSMarker(position: coordinate)
        pressedLocation.title = "Fuck U"
        pressedLocation.snippet = "pls work"
        pressedLocation.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        selectedAddress.text = "Address Selected: \n" + marker.title!
        return false
    }
    
    func requestData() -> Void {
        let urlPath = URL(string: baseURL + address + "&key=" + apiKey)!
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
                    let details = results[0] as! NSDictionary
                    let geometry = details["geometry"] as! NSDictionary
                    let location = geometry["location"] as! NSDictionary
                    let lat = location["lat"] as! CLLocationDegrees
                    let lng = location["lng"] as! CLLocationDegrees
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    
                    // To access the main thread so the marker can be created asynchronously
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.mapView.animate(toLocation: coordinate)
                        
                        // Add marker for default address
                        let defaultAddress = GMSMarker(position: coordinate)
                        defaultAddress.title = "Your default address"
                        defaultAddress.map = self?.mapView
                        self?.mapView.selectedMarker = defaultAddress
                        self?.selectedAddress.text = "Address Selected: \n" + defaultAddress.title!
                        return
                    }
                } catch {
                    print("error: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func getMarkerAddress() {
        let selectedMarker = mapView.selectedMarker
        
        geocoder.reverseGeocodeCoordinate((selectedMarker?.position)!) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result: GMSAddress = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = (selectedMarker?.position)!
                marker.title = result.lines?[0]
                marker.snippet = result.lines?[1]
                marker.map = self.mapView
            }
        }
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
//        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude:(location?.coordinate.longitude)!, zoom: 14)
//        mapView.animate(to: camera)
        
        // Add marker for current location
        let currentPosition = GMSMarker(position: .init(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!))
        currentPosition.title = "Your current location"
        currentPosition.map = mapView
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func goToSubmit(_ sender: AnyObject) {
        // check address
        
        performSegue(withIdentifier: "mapToSubmitSegue", sender: self)
        
        // Do something with selected?.position
    }
	
    @IBAction func returnToPreviousScreen(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        // performSegue(withIdentifier: "mapToProductSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
