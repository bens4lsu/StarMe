//
//  TimeInterval.swift
//  StarMe
//
//  Created by Ben Schultz on 8/5/19.
//  Copyright © 2019 com.concordbusinessservicesllc. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var durationText: String {
        get {
            let durationMinutes = Int(self / 60)
            let durationSeconds = Int(self.truncatingRemainder(dividingBy: 60.0))
            let strSeconds = ("0" + String(durationSeconds)).suffix(2)
            return String(durationMinutes) + ":" + strSeconds
        }
    }
}
