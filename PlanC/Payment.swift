//
//  Payment.swift
//  PlanC
//
//  Created by Yulong Tan on 12/11/16.
//  Copyright © 2016 PlanB. All rights reserved.
//

import Foundation

public struct Payment {
    
    public var paymentName: String
    public var cardNumber: String
    public var expirationDate: String
    public var securityCode: String
    public var nameOnCard: String
    
    var toString: String {
        return paymentName + "\n" + cardNumber + "\n" + nameOnCard
    }
    
    init(paymentName: String, cardNumber: String, expirationDate: String, securityCode: String, nameOnCard: String) {
        self.paymentName = paymentName
        self.cardNumber = cardNumber
        self.expirationDate = expirationDate
        self.securityCode = securityCode
        self.nameOnCard = nameOnCard
    }
    
    public func getPaymentName() -> String {
        return self.paymentName
    }
    
    public func getCardNumber() -> String {
        return self.cardNumber
    }
    
    public func getExpirationDate() -> String {
        return self.expirationDate
    }
    
    public func getSecurityCode() -> String {
        return self.securityCode
    }
    
    public func getNameOnCard() -> String {
        return self.nameOnCard
    }
    
    public func toAnyObject() -> Any {
        return [
            "Name": self.paymentName,
            "Number": self.cardNumber,
            "Expiration": self.expirationDate,
            "Security Code": self.securityCode,
            "Name on Card": self.nameOnCard
        ]
    }
}
