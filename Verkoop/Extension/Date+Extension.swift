//
//  Date+Extension.swift
//  Verkoop
//
//  Created by Vijay on 10/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension Date {
    
    static func getDate(dateString:String)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)
    }
    
    func checkDay(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let notifDate = dateFormatter.date(from: dateFormatter.string(from: date))
        let todaysDate = dateFormatter.date(from: dateFormatter.string(from: self))
        let days = daysBetweenDate(startDate: todaysDate!, endDate: notifDate!)
        if days == 0 {
            return "Today"
        } else if days == -1 {
            return "Yesterday"
        } else {
            return Date.getWeekday(date: notifDate!)
        }
    }
    
    func checkChatListDay(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let notifDate = dateFormatter.date(from: dateFormatter.string(from: date))
        let todaysDate = dateFormatter.date(from: dateFormatter.string(from: self))
        let days = daysBetweenDate(startDate: todaysDate!, endDate: notifDate!)
        if days == 0 {
            return Date.getTime(date:date)
        } else if days == -1 {
            return "Yesterday"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    func daysBetweenDate(startDate: Date, endDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func getHeader(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let chatDate = dateFormatter.date(from: dateFormatter.string(from: date))
        let todaysDate = dateFormatter.date(from: dateFormatter.string(from: self))
        let days = daysBetweenDate(startDate: todaysDate!, endDate: chatDate!)
        if days == 0 {
            return "Today"
        } else if days == -1 {
            return "Yesterday"
        } else {
            return dateFormatter.string(from:chatDate!)
        }
    }
    
    static func getWeekday(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    static func getTime(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    static func getDateDDMMMYYYY(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    static func getDateFromTimestamp(timeStamp:Int64, formatter:DateFormatter) -> String {
        let doubleTime = Double(timeStamp)
        let date = Date(timeIntervalSince1970: doubleTime/1000)
        let dateString = Date().checkChatListDay(date: date)
        return dateString // formatter.string(from: date)
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.timeZone = TimeZone.current
        let result = dateFormatter.string(from: self)
        return result
    }
    
    func getYear()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.timeZone = TimeZone.current
        let result = dateFormatter.string(from: self)
        return result
    }
    
    func getYearMonth()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        dateFormatter.timeZone = TimeZone.current
        let result = dateFormatter.string(from: self)
        return result
    }
    
    var currentDayMonthYear: (day:Int, month:Int, year:Int) {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        return (components.day!, components.month!, components.year!)
    }
    
}
