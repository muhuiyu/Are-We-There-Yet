//
//  MapViewModel.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/5/22.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

class MapViewModel {
    private let disposeBag = DisposeBag()
    
    var title: String { return "Uber" }
    var location: BehaviorRelay<Location> = BehaviorRelay(value: LocationManager.shared.getCurrentLocation())
    var displayCoordinates: BehaviorRelay<CLLocationCoordinate2D> = BehaviorRelay(value: CLLocationCoordinate2D())
    
    let searchViewController = SearchViewController()
    let confirmLocationViewController = ConfirmLocationViewController()
    
    init() {
        print(location.value.coordinates)
        location
            .asObservable()
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
    }
}

extension MapViewModel {
    
}

