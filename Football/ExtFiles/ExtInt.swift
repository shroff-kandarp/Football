//
//  ExtInt.swift
//  Football
//
//  Created by Kandarp Shroff on 04/10/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

extension Int {
    var ordinal: String {
        get {
            var suffix = "th"
            switch self % 10 {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default: ()
            }
            if 10 < (self % 100) && (self % 100) < 20 {
                suffix = "th"
            }
            return String(self) + suffix
        }
    }
}
