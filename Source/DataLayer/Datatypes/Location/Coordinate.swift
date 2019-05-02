//
//  Coordinate.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 5/2/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import CoreLocation

final class Coordinate {
    var latitude: Double = 0
    var longitude: Double = 0

    init(latitude: CLLocationDegrees,
         longitude: CLLocationDegrees
        ) {
        self.latitude = latitude
        self.longitude = longitude
    }

    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

