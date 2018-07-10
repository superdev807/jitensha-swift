//
//  User.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import ObjectMapper

class User: Model {
    var email: String?
    var password: String?
    var token: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        email <- map["email"]
        password <- map["password"]
        token <- map["token"]
    }
    
    required init(){
        super.init()
    }
    
    required init?(map: Map){
        super.init(map: map)
    }
    
}

