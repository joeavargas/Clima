//
//  Date.swift
//  Clima
//
//  Created by Joe Vargas on 5/23/21.
//

import Foundation

extension Date{
    // Returns "Jan 01"
    func shortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
    
    // Returns "10:00" or "22:00"
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        return dateFormatter.string(from: self)
    }
    
    // Returns "Sunday", "Monday", etc...
    func dayOfTheWeek() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    // Returns "Thursday, May 20, 2021"
    func dayAndDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
