//
//  User.swift
//  PlanC
//
//  Created by Yulong Tan on 12/6/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import Foundation

public struct User {
    
    public var email: String
    public var address: String
    public var creditCard: String
    
    init(email: String, address: String, creditCard: String) {
        self.email = email
        self.address = address
        self.creditCard = creditCard
    }
    
    public func getEmail() -> String {
        return self.email
    }

    public func getAddress() -> String {
        return self.address
    }
    
    public func getCreditCard() -> String {
        return self.creditCard
    }
    
    public func toAnyObject() -> Any {
        return [
            "added by": self.email,
            "address": self.address,
            "creditCard": self.creditCard
        ]
    }
}
