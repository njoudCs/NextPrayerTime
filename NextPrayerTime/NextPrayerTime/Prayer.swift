//
//  Prayer.swift
//  NextPrayerTime
//
//  Created by Njoud saud Al-Najem on 22.07.2023.
//

import Foundation
import SwiftUI
import Adhan

extension Adhan.Prayer {
    var prayerName: LocalizedStringKey {
        switch self {
        case .fajr:
            return "Fajr"
        case .sunrise:
            return "Sunrise"
        case .dhuhr:
            return "Dhuhr"
        case .asr:
            return "Asr"
        case .maghrib:
            return "Maghrib"
        case .isha:
            return "Isha"
        }
    }
}
