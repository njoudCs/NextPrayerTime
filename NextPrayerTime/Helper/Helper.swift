//
//  Helper.swift
//  NextPrayerTime
//
//  Created by Njoud saud Al-Najem on 22.07.2023.
//


import Foundation
import UIKit

struct Helper {
    
    
    static func isArabic() -> Bool {
        if let local = Locale.current.language.languageCode?.identifier {
            if local == "ar" {
                return true
            }
        }
        return false
    }
    
}

