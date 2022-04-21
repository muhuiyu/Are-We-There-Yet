//
//  Location.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/8/22.
//

import Foundation
import CoreLocation

struct Location {
    var title: String
    var coordinates: CLLocationCoordinate2D?
    
    enum LocationError: Error {
        case missingCoordinates
        case missingPlacemark
    }
}

extension Location {
    func getAddress(completion: @escaping (_ address: String?, _ error: Error?) -> Void) {
        guard let coordinates = self.coordinates else { return completion(nil, LocationError.missingCoordinates) }
        
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let geoCoder: CLGeocoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("reverse geoCoder fail: \(error.localizedDescription)")
                return completion(nil, error)
            }
            guard
                let placemarks = placemarks,
                !placemarks.isEmpty
            else { return completion(nil, LocationError.missingPlacemark) }
            
            var addressString = ""
            let placemark = placemarks[0]
            
            print(placemark.country,
                  placemark.locality,
                  placemark.subLocality,
                  placemark.thoroughfare,
                  placemark.postalCode,
                  placemark.subThoroughfare)
            
            if let subLocality = placemark.subLocality {
                addressString = addressString + subLocality + ", "
            }
            if let thoroughfare = placemark.thoroughfare {
                addressString = addressString + thoroughfare + ", "
            }
            if let locality = placemark.locality {
                addressString = addressString + locality + ", "
            }
            if let country = placemark.country {
                addressString = addressString + country + ", "
            }
            if let postalCode = placemark.postalCode  {
                addressString = addressString + postalCode
            }
            return completion(addressString, nil)
        }
    }
}
