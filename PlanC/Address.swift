//
//  Address.swift
//  PlanC
//
//  Created by Yulong Tan on 12/11/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import Foundation

public struct Address {
    
    public var addressName: String
    public var address: String
    public var city: String
    public var state: String
    public var zipcode: String
    
    var toString: String {
        return addressName + "\n" + address + "\n" + city + ", " + state + " " + zipcode
    }
    
    init(addressName: String, address: String, city: String, state: String, zipcode: String) {
        self.addressName = addressName
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
    }

//
//    extension String {
//        func isValidEmail() -> Bool {
//            let regex = NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive, error: nil)
//            return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
//        }
//    }
    
    public func getAddressName() -> String {
        return self.addressName
    }
    
    public func getAddress() -> String {
        return self.address
    }
    
    public func getCity() -> String {
        return self.city
    }
    
    public func getState() -> String {
        return self.state
    }
    
    public func getZipcode() -> String {
        return self.zipcode
    }
    
    public func toAnyObject() -> Any {
        return [
            "Name": self.addressName,
            "Address": self.address,
            "City": self.city,
            "State": self.state,
            "Zipcode": self.zipcode
        ]
    }
}
