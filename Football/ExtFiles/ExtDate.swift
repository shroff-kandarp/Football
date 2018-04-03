//
//  ExtDate.swift
//  DriverApp
//
//  Created by NEW MAC on 02/09/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import Foundation
extension Date{
    func addedBy(minutes:Int) -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: DateFormatter().timeZone.identifier)!
        return cal.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func addedBy(seconds:Int) -> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: DateFormatter().timeZone.identifier)!
        return cal.date(byAdding: .second, value: seconds, to: self)!
    }
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getDayName() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayName = dateFormatter.string(from:self)
        
        return dayName
    }
    
    func getDayNum() -> String{
        let currentDay = Calendar.current.ordinality(of: .day, in: .month, for: self)
        return "\(currentDay!.ordinal)"
    }
    
    func convertDateToYMD() -> String
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
//        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: self)
        
    }
}
