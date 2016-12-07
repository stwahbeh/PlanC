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
    public var password: String
    public var address: String
    public var creditCard: String
    
    init(email: String, password: String, address: String, creditCard: String) {
        self.email = email
        self.password = password
        self.address = address
        self.creditCard = creditCard
    }
    
    public func getEmail() -> String {
        return self.email
    }
    
    public func getPassword() -> String {
        return self.password
    }
    
    public func getAddress() -> String {
        return self.address
    }
    
    public func getCreditCard() -> String {
        return self.creditCard
    }
}
