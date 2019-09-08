//
//  ViewController.swift
//  LocationOnMap
//
//  Created by MacBook on 9/8/19.
//  Copyright © 2019 Shakhboz. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterUserLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapView()
        configureLocationManager()
        enableLocationServices()
        centerMapOnUserLocation()
        
        setupUI()
    }
    
    @objc func handleCenterUserLocation() {
        print("Center on user location")
        centerMapOnUserLocation()
    }
    
    func setupUI() {
        
        view.addSubview(centerMapButton)
        centerMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
        centerMapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        centerMapButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerMapButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerMapButton.layer.cornerRadius = 50 / 2
        centerMapButton.alpha = 1
    }
    
    func centerMapOnUserLocation() {
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func configureMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Location authorization status isn't determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location authorization status is restricted")
        case .denied:
            print("Location authorization status is denied")
        case .authorizedAlways:
            print("Location authorization status is authorized always")
        case .authorizedWhenInUse:
            print("Location authorization status is authorized when in use")
        @unknown default:
            print("Location authorization status...")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}

