//
//  MapViewController.swift
//  Are We There Yet?
//
//  Created by Mu Yu on 4/5/22.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel
import RxSwift

class MapViewController: ViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel = MapViewModel()
    let mapView = MKMapView()
    let panel = FloatingPanelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureConstraints()
        configureGestures()
        configureSignals()
    }
}
// MARK: - Actions
extension MapViewController {
    private func updateMapView(to location: Location) {
        print("\(location.title): \(location.coordinates)")
        guard let coordinates = location.coordinates else { return }

//        panel.move(to: .tip, animated: true, completion: nil)
        self.viewModel.confirmLocationViewController.viewModel.selectedLocation.accept(location)
        self.panel.set(contentViewController: self.viewModel.confirmLocationViewController)

        mapView.removeAnnotations(mapView.annotations)

        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)

        mapView.setRegion(
            MKCoordinateRegion(
                center: coordinates,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.8,
                    longitudeDelta: 0.8
                )
            ),
            animated: true
        )
    }
}
// MARK: - View Config
extension MapViewController {
    private func configureViews() {
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        panel.set(contentViewController: viewModel.searchViewController)
        panel.addPanel(toParent: self)
    }
    private func configureConstraints() {
        mapView.snp.remakeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func configureGestures() {
        
    }
    private func configureSignals() {
        viewModel.searchViewController.viewModel.selectLocation
            .asObservable()
            .subscribe(onNext: { value in
                if let value = value {
                    self.updateMapView(to: value)
                }
            })
            .disposed(by: disposeBag)
    }
}
