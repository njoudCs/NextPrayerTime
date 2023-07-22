//
//  PrayersTimeView.swift
//  NextPrayerTime
//
//  Created by Njoud saud Al-Najem on 22.07.2023.
//



import Adhan
import CoreLocation
import Foundation
import SwiftUI

struct PrayersTimeView: View {
    @EnvironmentObject var env: EnvViewModel
    @StateObject var vm = ViewModel()
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                if let prayers = env.prayers {
                    VStack(spacing: 4) {
                        VStack {
                            
                            if let nextPrayerName = vm.nextPrayer?.prayerName {
                                
                                HStack {
                                    Text("Prayer")
                                    Text(nextPrayerName)
                                    Text("After")
                                }
                                .font(.title)
                                
                                
                            }
                            
                            Text(vm.nextPrayerCountDown) .onReceive(vm.timer, perform: { _ in
                                vm.currentTime = Date.now
                            })
                            
                        }.multilineTextAlignment(.center)
                        
                        
                    }
                    
                } else {
                    
                }
                Spacer()
            }
            .padding(.top, 1)
            
        }.onAppear{
            vm.requestLocation()
        }
    }
}



class ViewModel: ObservableObject {
    let env: EnvViewModel = EnvViewModel.shared
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    @Published var showLocationIndicator: Bool = false
    @Published var showLocationDeniedAlert: Bool = false
    @Published var currentTime = Date.now
    
    var nextPrayerCountDown: String {
        guard let prayers = env.prayers else { return "ERROR" }
        var nextPrayerDate: Date
        if let nextPrayer = prayers.nextPrayer() {
            nextPrayerDate = prayers.time(for: nextPrayer)
        } else {
            nextPrayerDate = prayers.fajr.addingTimeInterval(60 * 60 * 24)
        }
        
        let calendar = Calendar(identifier: .gregorian)
        
        let components = calendar
            .dateComponents([.hour, .minute, .second],
                            from: currentTime,
                            to: nextPrayerDate
            )
        
        return String(format: "%02d:%02d:%02d",
                      components.hour ?? 00,
                      components.minute ?? 00,
                      components.second ?? 00
        )
    }
    
    
    
    
    
    
    
    var nextPrayer: Adhan.Prayer? {
        guard let prayers = env.prayers else { return nil }
        return prayers.nextPrayer() ?? prayers.currentPrayer(at: prayers.fajr)
    }
    
    func requestLocation() {
        showLocationIndicator = true
        env.requestLocation { location in
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showLocationIndicator = false
                self.env.updateLocation(latitude: latitude, longitude: longitude)
            }
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
