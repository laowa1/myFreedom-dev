//
//  GeopositionManager.swift
//  MyFreedom
//
//  Created by m1pro on 15.05.2022.
//

import CoreLocation

class GeopositionManager: NSObject {
    
    var showLocationSettings: (() -> Void)?
    private var locationManager = CLLocationManager()
    private var closure: ((Double?, Double?) -> Void)?
    private let logger: BaseLogger
    
    init(logger: BaseLogger) {
        self.logger = logger
    }
    
    func getCurrentUserPosition(completion: @escaping (Double?, Double?) -> Void) {
        closure = completion
        DispatchQueue.main.async {
            self.locationManager.requestAlwaysAuthorization()
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension GeopositionManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations _: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        closure?(location.latitude, location.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        closure?(nil, nil)
        stopUpdatingLocation()
    }
    
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        enum Permission: String {
            case granted = "granted"
            case notGranted = "not_granted"
        }

        var permissionStatus: Permission

        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            permissionStatus = .granted
            let params: [String: String] = ["answer": permissionStatus.rawValue]
            logger.sendAnalyticsEvent(event: "Geo popup pressed", with: params)
        case .denied,
             .restricted:
            permissionStatus = .notGranted
            let params: [String: String] = ["answer": permissionStatus.rawValue]
            logger.sendAnalyticsEvent(event: "Geo popup pressed", with: params)
            
            if status == .denied {
                showLocationSettings?()
            }
        default:
            break
        }
    }
    
    
}
