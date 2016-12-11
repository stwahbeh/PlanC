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
    
    init(addressName: String, address: String, city: String, state: String, zipcode: String) {
        self.addressName = addressName
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
    }
    
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
