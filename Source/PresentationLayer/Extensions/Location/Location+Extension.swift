//
//  Location+Extension.swift
//  FamillyOrganizer
//
//  Created by Yurii Tsymbala on 5/11/19.
//  Copyright © 2019 Yurii Tsymbala. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreLocation

extension String {

    func formattedAddress(fromPlacemark placemark: CLPlacemark?) -> String {
        var address = ""

        //        if let country = placemark?.country{
        //            address = constructAddressString(address, newString: country)
        //        }

//        if let state = placemark?.addressDictionary?["State"] as? String {
//            address = constructAddressString(address, newString: state)
//        }

        if let city = placemark?.addressDictionary?["City"] as? String {
            address = constructAddressString(address, newString: city)
        }

        if let name = placemark?.addressDictionary?["Name"] as? String {
            address = constructAddressString(address, newString: name)
        }

        return address
    }

    func constructAddressString(_ string: String, newString: String) -> String {
        var address = string

        if !address.isEmpty {
            address = address.appendingFormat(", \(newString)")
        } else {
            address = address.appending(newString)
        }

        return address
    }
}

func getPlace(for location: CLLocation,
              completion: @escaping (CLPlacemark?) -> Void) {

    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        
        guard error == nil else {
            print("*** Error in \(#function): \(error!.localizedDescription)")
            completion(nil)
            return
        }

        guard let placemark = placemarks?[0] else {
            print("*** Error in \(#function): placemark is nil")
            completion(nil)
            return
        }

        completion(placemark)
    }
}
