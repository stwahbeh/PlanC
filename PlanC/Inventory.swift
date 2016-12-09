//
//  inventory.swift
//  PlanC
//
//  Created by sam wahbeh on 12/8/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import Foundation
import Firebase

public struct Inventory {
    
    public var productName: String
    public var inventory: Int
    public var price: Double
    
    let key: String
    let ref: FIRDatabaseReference?
    
    init(productName: String, inventory: Int, price: Double, key: String = "") {
        self.key = key
        self.productName = productName
        self.inventory = inventory
        self.price = price
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [[String: Any]]
        productName = snapshotValue[0][self.productName] as! String
        inventory = snapshotValue[0][self.inventory] as! Int
        price = snapshotValue[0][self.price] as! Double
        ref = snapshot.ref
        
    }
    
    public func getProductName() -> String {
        return self.productName
    }
    
    public func getInventory() -> Int {
        return self.inventory
    }
    
    public func getPrice() -> Double {
        return self.price
    }
    
    public func toAnyObject() -> Any {
        return [
            "product name": self.productName,
            "inventory": self.inventory,
            "price": self.price
        ]
    }
}
