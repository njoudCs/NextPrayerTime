//
//  EnvViewModel.swift
//  NextPrayerTime
//
//  Created by Njoud saud Al-Najem on 22.07.2023.
//



import Adhan
import CoreLocation
import Foundation
import SwiftUI

class EnvViewModel: ObservableObject {
    static let shared = EnvViewModel()
    @Published var prayers: PrayerTimes?
    
    
    
    @AppStorage(UserDefaultsKey.latitude) private var latitude: Double?
    @AppStorage(UserDefaultsKey.longitude) private var longitude: Double?
    
    
    
    private var locationManager = LocationManager.instance
    
    
    private var isArabic: Bool
    
    init() {
        isArabic = Helper.isArabic()
        guard
            let latitude = latitude,
            let longitude = longitude
        else { return }
    }
    
    func updateLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
        
        showPrayerTime(latitude: latitude, longitude: longitude)
        
    }
    
    
    func requestLocation(onUpdateLocation: @escaping (_ location: CLLocation) -> Void, completionHandler: @escaping (_ authorizationStatus: CLAuthorizationStatus) -> Void) {
        locationManager.requestLocation(onUpdateLocation: onUpdateLocation, completionHandler: completionHandler)
    }
    
    var calculationMethod = CalculationMethod.ummAlQura
    
    var madhabType = Madhab.shafi
    
    
    func showPrayerTime(latitude: Double, longitude: Double, calculationMethod: CalculationMethod = .ummAlQura) {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let coordinates = Coordinates(latitude: latitude, longitude: longitude)
        let params = calculationMethod.params
        let date = cal.dateComponents([.year, .month, .day], from: Date.now)
        guard let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: params) else { return }
        self.prayers = prayers
    }
    
}


