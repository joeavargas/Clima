//
//  IconManager.swift
//  Clima
//
//  Created by Joe Vargas on 5/23/21.
//

import UIKit

func returnIconImage(from icon: String) -> UIImage{
    
    switch icon {
    // Clear
    case "01d":
        return UIImage(systemName: "sun.max")!
    case "01n":
        return UIImage(systemName: "moon.stars")!
        
    // Cloudy
    case "02d":
        return UIImage(systemName: "cloud")!
    case "02n":
        return UIImage(systemName: "cloud.moon")!
    case "03d":
        return UIImage(systemName: "cloud")!
    case "03n":
        return UIImage(systemName: "cloud.moon")!
    case "04d":
        return UIImage(systemName: "cloud")!
    case "04n":
        return UIImage(systemName: "cloud.moon")!
        
    // Rain / Thunderstorm
    case "09d":
        return UIImage(systemName: "cloud.rain")!
    case "09n":
        return UIImage(systemName: "cloud.rain")!
    case "10d":
        return UIImage(systemName: "cloud.heavyrain")!
    case "10n":
        return UIImage(systemName: "cloud.heavyrain")!
    case "11d":
        return UIImage(systemName: "cloud.sun.bolt")!
    case "11n":
        return UIImage(systemName: "cloud.moon.bolt")!
        
    // Snow
    case "13d":
        return UIImage(systemName: "snow")!
    case "13n":
        return UIImage(systemName: "snow")!
        
    // Fog
    case "50d":
        return UIImage(systemName: "cloud.fog")!
    case "50n":
        return UIImage(systemName: "cloud.fog")!
    default:
        return UIImage(systemName: "exclamationmark.triangle")!
    }
}
