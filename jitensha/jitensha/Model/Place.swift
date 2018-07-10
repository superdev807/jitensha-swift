//
//  Place.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    var id: String!
    var info: Place!
}

class Place: Model {
    
    var id: String?
    var name: String?
    var latitude: String?
    var longitude: String?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude ?? "0") ?? 0, longitude: Double(longitude ?? "0") ?? 0)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        name <- map["name"]
        latitude <- map["location.lat"]
        longitude <- map["location.lng"]
    }
    
    required init(){
        super.init()
    }
    
    required init?(map: Map){
        super.init(map: map)
    }

    func annotation() -> PlaceAnnotation {
        let annotation = PlaceAnnotation()
        annotation.id = self.id ?? ""
        let centerCoordinate = self.coordinate
        annotation.coordinate = centerCoordinate
        annotation.title = self.name ?? ""
        annotation.info = self
        return annotation
    }
    
}
