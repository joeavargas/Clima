//
//  Network.swift
//  Clima
//
//  Created by Joe Vargas on 5/22/21.
//

import Foundation
import CoreLocation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    
    lazy var lat = 29.772674560546875
    lazy var long = -95.39841050291005
    lazy var API_KEY = "518596e8c6802246f190698a108afa4a"
    lazy var URL_BASE = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alerts&appid=\(API_KEY)"
    let session = URLSession(configuration: .default)
    
    func fetchWeatherData(){
            let url = URL(string: "\(URL_BASE)")
            
            let task = session.dataTask(with: url!) { data, response, error in
                DispatchQueue.main.async {
                    
                    // handle session error
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                    
                    // ensure there is data and a server response
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        print("Invalid data or response")
                        return
                    }
                    
                    // handle server response codes
                    do{
                        switch response.statusCode{
                        case 200:
                            // parse successful result (weather data)
                            print(data)
                        default:
                            // handle unsuccessful error (400s)
                            print("Error 400")
                        }
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    
}
