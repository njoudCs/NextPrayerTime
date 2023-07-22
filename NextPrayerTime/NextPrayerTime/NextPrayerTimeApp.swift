//
//  NextPrayerTimeApp.swift
//  NextPrayerTime
//
//  Created by Njoud saud Al-Najem on 22.07.2023.
//

import SwiftUI

@main
struct NextPrayerTimeApp: App {
    @StateObject var env = EnvViewModel.shared
    
    var body: some Scene {
        
        
        WindowGroup {
            
            Group {
                
                AppTapView()
            }.environmentObject(env)
            
        }
        
    }
    
}
