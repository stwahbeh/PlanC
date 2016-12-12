//
//  Order.swift
//  PlanC
//
//  Created by sam wahbeh on 12/11/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import Foundation

public struct Order {
    
    public var address: String
    public var cost: String
    public var email: String
    public var qty: String
    
    init(address: String, cost: String, email: String, qty: String) {
        self.address = address
        self.cost = cost
        self.email = email
        self.qty = qty
    }
    
    public func getEmail() -> String {
        return self.email
    }
    
    public func getAddress() -> String {
        return self.address
    }
    
    public func getCost() -> String {
        return self.cost
    }
    
    public func getQty() -> String {
        return self.cost
    }
    
    public func toAnyObject() -> Any {
        return [
            "address": self.address,
            "cost": self.cost,
            "email": self.email,
            "qty": self.qty
        ]
    }
}
