//
//  Payment.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentRequest: Model {
    
    var placeId: String?
    var number: String?
    var name: String?
    var cvv: String?
    var expiryMonth: String?
    var expiryYear: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        placeId <- map["placeId"]
        number <- map["number"]
        name <- map["name"]
        cvv <- map["cvv"]
        expiryMonth <- map["expiryMonth"]
        expiryYear <- map["expiryYear"]
    }
    
    required init(){
        super.init()
    }
    
    init(placeId: String?, number: String?, name: String?, cvv: String?, expiryMonth: String?, expiryYear: String?) {
        super.init()
        self.placeId = placeId
        self.number = number
        self.name = name
        self.cvv = cvv
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
    }
    
    required init?(map: Map){
        super.init(map: map)
    }
    
}

