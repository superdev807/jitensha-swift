//
//  Payment.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import ObjectMapper

class Payment: Model {

    var placeId: String?
    var cardNumber: String?
    var cardName: String?
    var cardCVV: String?
    var cardExpiryMonth: String?
    var cardExpiryYear: String?
    var createdAt: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        createdAt <- map["createdAt"]
        placeId <- map["placeId"]
        cardNumber <- map["creditCard.number"]
        cardName <- map["creditCard.name"]
        cardCVV <- map["creditCard.cvv"]
        cardExpiryMonth <- map["creditCard.expiryMonth"]
        cardExpiryYear <- map["creditCard.expiryYear"]
    }
    
    required init(){
        super.init()
    }
    
    init(placeId: String?, number: String?, name: String?, cvv: String?, expiryMonth: String?, expiryYear: String?) {
        super.init()
        self.placeId = placeId
        self.cardNumber = number
        self.cardName = name
        self.cardCVV = cvv
        self.cardExpiryMonth = expiryMonth
        self.cardExpiryYear = expiryYear
    }
    
    required init?(map: Map){
        super.init(map: map)
    }
    
}
