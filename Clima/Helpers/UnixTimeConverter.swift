//
//  UnixTimeConverter.swift
//  Clima
//
//  Created by Joe Vargas on 5/23/21.
//

import Foundation

func currentDateFrom(unixDate: Double?) -> Date?{
    if unixDate != nil{
        return Date(timeIntervalSince1970: unixDate!)
    } else {
        return Date()
    }
}
