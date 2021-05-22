//
//  Weather.swift
//  Clima
//
//  Created by Joe Vargas on 5/22/21.
//

import Foundation

struct WeatherData: Codable{
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let weather: [Weather]
        
    struct Weather: Codable{
        let description: String
        let icon: String
    }
}

struct Hourly: Codable{
    let dt: Int
    let temp: Double
    let weather: [Weather]
       
    struct Weather: Codable{
        let icon: String
    }
    
}

struct Daily: Codable{
    let dt: Int
    let temp: Temp
    let weather: [Weather]
    
    struct Temp: Codable {
        let max: Double
    }
    
    struct Weather: Codable{
        let icon: String
    }
}
