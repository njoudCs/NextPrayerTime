//
//  LocationManager.swift
//  NextPrayerTime
//
//  Created by Njoud saud Al-Najem on 22.07.2023.
//



import CoreLocation
import Foundation
import SwiftUI

class LocationManager: NSObject {
    static let instance = LocationManager()
    
    private var manger = CLLocationManager()
    
    var onUpdateLocation: ((_ location: CLLocation) -> Void)?
    
    override init() {
        super.init()
        manger.delegate = self
        manger.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func requestLocation(onUpdateLocation: @escaping (_ location: CLLocation) -> Void, completionHandler: @escaping (_ authorizationStatus: CLAuthorizationStatus) -> Void) {
        let status = manger.authorizationStatus
        switch status {
        case .notDetermined:
            self.onUpdateLocation = onUpdateLocation
            manger.requestAlwaysAuthorization()
            completionHandler(.notDetermined)
        case .authorizedWhenInUse, .authorizedAlways, .authorized:
            self.onUpdateLocation = onUpdateLocation
            manger.requestLocation()
            completionHandler(.authorizedAlways)
        case .denied: completionHandler(.denied)
            
        default:
            return
        }
    }
    
    
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        if let onUpdateLocation = onUpdateLocation {
            onUpdateLocation(location)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let location = manager.location else { return }
        if let onUpdateLocation = onUpdateLocation {
            onUpdateLocation(location)
        }
    }
    
    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Error: " + error.localizedDescription)
    }
    
    class ViewModel: ObservableObject {
        let env: EnvViewModel = EnvViewModel.shared
        @Published var isLocationAuthrised: Bool = false
        @Published var showLocationDeniedAlert: Bool = false
        @Published var showMainApp: Bool = false
        
        
        func requestLocation() {
            env.requestLocation { location in
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                self.env.updateLocation(latitude: latitude, longitude: longitude)
                self.isLocationAuthrised = true
                
                
            } completionHandler: { authorizationStatus in
                switch authorizationStatus {
                case .denied:
                    self.showLocationDeniedAlert = true
                    
                default:
                    return
                }
            }
        }
        
    }
}
