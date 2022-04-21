//
//  LocationManager.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/5/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    public func getCurrentLocation() -> Location {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return Location(title: "current", coordinates: manager.location?.coordinate)
        default:
            return Location(title: "", coordinates: nil)
        }
    }
    
    public func findLocations(with query: String, completion: @escaping(([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                return completion([])
            }
            
            let models: [Location] = places.compactMap { place in
                var name = ""
                
                if let locationName = place.name {
                    name += locationName
                }
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                if let country = place.country {
                    name += ", \(country)"
                }
                let result = Location(
                    title: name,
                    coordinates: place.location?.coordinate
                )
                return result
            }
            
            return completion(models)
        }
    }
}

