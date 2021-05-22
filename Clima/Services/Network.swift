//
//  Network.swift
//  Clima
//
//  Created by Joe Vargas on 5/22/21.
//

import Foundation
import CoreLocation

typealias OnApiSuccess = (WeatherData) -> Void
typealias OnApiError = (String) -> Void

class NetworkRequest {
    
    static let shared = NetworkRequest()

    lazy var API_KEY = "518596e8c6802246f190698a108afa4a"
    let session = URLSession(configuration: .default)
    
    func fetchWeatherData(location: CLLocationCoordinate2D, onSuccess: @escaping OnApiSuccess, onError: @escaping OnApiError){
        let URL_BASE = "https://api.openweathermap.org/data/2.5/onecall?lat=\(location.latitude)&lon=\(location.longitude)&exclude=minutely,alerts&appid=\(API_KEY)"
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
                            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                            onSuccess(weatherData)
                        default:
                            // handle unsuccessful error (400s)
                            print("Error 400")
                            onError(error!.localizedDescription)
                        }
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    
}
