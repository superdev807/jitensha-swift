//
//  Model.swift
//  RanchLife
//
//  Created by Edvard on 2017-07-05.
//  Copyright © 2017 Lead InSite. All rights reserved.
//

import ObjectMapper

class Model: Mappable {
    
    var code: Int?
    var message: String?
    
    required init(){}
    
    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map){
        code <- map["code"]
        message <- map["message"]
    }
}
