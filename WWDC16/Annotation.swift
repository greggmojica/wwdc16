//
//  Annotation.swift
//  GreggMojica
//
//  Created by Gregg Mojica on 4/18/16.
//  Copyright (c) 2016 Gregg Mojica. All rights reserved.
//


import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    var title: String?
    var locationTitle: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationTitle = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationTitle
    }
    
    func changeColor(isTrue:Bool) -> MKPinAnnotationColor  {
        if true {
            return .Red
        } else {
            //return .Purple
        }
        
    }
}