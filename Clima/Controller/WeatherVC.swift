//
//  WeatherVC.swift
//  Clima
//
//  Created by Joe Vargas on 5/16/21.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    
    // IBOulet
    @IBOutlet weak var dayAndDate: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var forecastSegment: UISegmentedControl!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    
    // Properties
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var location: CLLocation?
    var weatherData: WeatherData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        
    }
    
    func updateUI(weatherData: WeatherData){
        dayAndDate.text = currentDateFrom(unixDate: weatherData.current.dt)?.dayAndDate()
        for current in weatherData.current.weather{
            weatherConditionLabel.text = current.description.capitalized
            weatherIconImage.image = returnIconImage(from: current.icon)
            
        }
        tempLabel.text = "\(Int(weatherData.current.temp))°"
    }


}

//MARK: - Location Delegates and Helper Functions
extension WeatherVC: CLLocationManagerDelegate{
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            
        } else {
            // TODO: Show alert letting the user know they have to turn this on
        }
    }
    
    func getUserCoordinates(){
        if let coordinates = locationManager.location?.coordinate{
            LocationService.shared.lattitude = coordinates.latitude
            LocationService.shared.longitude = coordinates.longitude
            print("Lat:", LocationService.shared.lattitude!)
            print("Long:", LocationService.shared.longitude!)
            NetworkRequest.shared.fetchWeatherData(location: coordinates) { data in
                print("PRINT: ", data)
                self.weatherData = data
                DispatchQueue.main.async {
                    // TODO: Update UI with weather data
                    self.updateUI(weatherData: data)
                }
            } onError: { errorMessage in
                // TODO: display error in an alert
                print("PRINT: ", errorMessage)
            }

        }
    }
    
    func checkLocationAuthorization(){
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            // do GPS location stuff
            getUserCoordinates()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //TODO: Show an alert instructing user how to turn on permission
            break
        case.notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //TODO: Show an alert instructing user how to turn on permission
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
        
        // get the latest location
        let latestLocation = locations.last!
        
        if latestLocation.horizontalAccuracy < 0 {
            return
        }
        
        // if location is nil or if user location has updated
        if location == nil || location!.horizontalAccuracy > latestLocation.horizontalAccuracy{
            location = latestLocation
            // stop location manager
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            // start reverse geocoding
            getCityLocalityInfo(from: location!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    // func to return location placemark(city info) based on latest location
    func getCityLocalityInfo(from location: CLLocation){
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if error == nil, let placemark = placemarks, !placemark.isEmpty{
                DispatchQueue.main.async {
                    print("PRINT: ", placemark.first?.locality!)
                    self.cityNameLabel.text = placemark.first?.locality!
                }
            }
        }
    }
}
