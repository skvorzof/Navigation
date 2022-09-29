//
//  MapViewController.swift
//  Navigation
//
//  Created by Dima Skvortsov on 21.09.2022.
//

import CoreLocation
import MapKit
import UIKit

protocol MapViewProtocol: AnyObject {
    func displayBranchLocations(_ locations: [Location])
}

class MapViewController: UIViewController, MapViewProtocol {

    private let presenter: MapPresenterProtocol

    private let locationManager = CLLocationManager()

    private var branchLocations: [CLLocationCoordinate2D] = []

    private let defaultLocation = CLLocationCoordinate2D(latitude: 59.9552185, longitude: 30.3538831)

    private lazy var mapKitView: MKMapView = {
        let view = MKMapView()
        view.mapType = .standard
        view.showsTraffic = false
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var clearPinsButton = UIBarButtonItem(
        image: UIImage(systemName: "trash"),
        style: .plain,
        target: self,
        action: #selector(didTapclearPinsButton))

    init(presenter: MapPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        locationManager.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongpress))
        longPress.minimumPressDuration = 0.5
        mapKitView.addGestureRecognizer(longPress)
        
        checkLocationAuthorization()
        configureLocationManager()

        presenter.requestBranchLocations()
    }
    
    @objc
    private func didTapLongpress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: mapKitView)
            let newCoordinate = mapKitView.convert(touchPoint, toCoordinateFrom: mapKitView)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location) {(placemarks, error) in
                if error != nil {
                    print("Ошибка добавления места \(String(describing: error))")
                } else {
                    if let placemark = placemarks?.first {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare! + " "
                        }
                    }
                    
                    if title == "" {
                        title = "Добавлено \(NSDate())"
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    
                    self.didTapclearPinsButton()
                    self.mapKitView.addAnnotation(annotation)
                    self.showNavigationRouteToBranch(withLocation: newCoordinate)
                }
            }
        }
        
    }

    private func setupView() {
        view.backgroundColor = .backgroundColor

        navigationItem.rightBarButtonItem = clearPinsButton
        navigationController?.navigationBar.tintColor = .red

        view.addSubview(mapKitView)

        NSLayoutConstraint.activate([
            mapKitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapKitView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapKitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapKitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func displayBranchLocations(_ locations: [Location]) {
        branchLocations = locations.map { $0.clLocation }
        let annotations = locations.map { location in
            let clLocation = location.clLocation
            let pin = MKPointAnnotation()
            pin.title = location.name
            pin.coordinate = clLocation
            return pin
        }
        mapKitView.addAnnotations(annotations)
    }

    @objc
    private func didTapclearPinsButton() {
        let annotation = mapKitView.annotations
        mapKitView.removeAnnotations(annotation)
        mapKitView.overlays.forEach { mapKitView.removeOverlay($0) }
        checkLocationAuthorization()
    }

    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            mapKitView.showsUserLocation = true
        case .denied, .restricted:
            assertionFailure("User denied location access")
        case .authorizedAlways:
            assertionFailure("Not supported mode, we only need authorization when in use")
            break
        @unknown default:
            assertionFailure("Not supported mode")
            break
        }
    }

    private func centerAndZoomInMapToLocation(_ location: CLLocationCoordinate2D) {
        mapKitView.setCenter(location, animated: true)

        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapKitView.setRegion(region, animated: true)

        mapKitView.showsUserLocation = true
    }

    private func showNavigationRouteToBranch(withLocation location: CLLocationCoordinate2D) {
        // Remove previous routes
        mapKitView.overlays.forEach { mapKitView.removeOverlay($0) }

        // Create a direction request
        let directionRequest = MKDirections.Request()

        // Create source and destination items
        let sourcePlacemark = MKPlacemark(coordinate: locationManager.location?.coordinate ?? defaultLocation)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)

        let destinationPlacemark = MKPlacemark(coordinate: location)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        // Configure a direction request
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking

        // Calculate direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self else {
                return
            }

            if error != nil {
                // Here we can show error alert to a user
                return
            }

            guard let response = response, let route = response.routes.first else {
                // Here we can show error alert to a user
                return
            }

            self.mapKitView.addOverlay(route.polyline, level: .aboveRoads)

            let routeRect = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegion(routeRect), animated: true)
        }
    }

    private func configureLocationManager() {
        locationManager.desiredAccuracy = 1.5
        locationManager.distanceFilter = 2
        locationManager.startUpdatingLocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        centerAndZoomInMapToLocation(location.coordinate)

        DispatchQueue.main.async { [weak self] in
            guard let self = self, let firstBranchLocation = self.branchLocations.first else {
                return
            }
            self.showNavigationRouteToBranch(withLocation: firstBranchLocation)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 55.0/255.0, green: 218.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        renderer.lineWidth = 10.0
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Marker")
        annotationView.glyphImage = UIImage(systemName: "figure.walk")
        annotationView.markerTintColor = UIColor(red: 55.0/255.0, green: 218.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        annotationView.glyphTintColor = .black
        if annotation.title == "My Location" {
            annotationView.glyphImage = UIImage(systemName: "smallcircle.filled.circle")
        }
        return annotationView
    }
}
