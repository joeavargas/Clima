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
    var currentWeather: Current?
    var hourlyWeather = [Hourly]()
    var dailyWeather = [Daily]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientBackground()

        forecastCollectionView.register(ForecastCollectionViewCell.nib(), forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier)
        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
        checkLocationServices()
        
        forecastSegment.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
    }
    
    func addGradientBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func updateCurrentWeatherUIWith(currentWeather: Current){
        dayAndDate.text = currentDateFrom(unixDate: currentWeather.dt)?.dayAndDate()
        for current in currentWeather.weather{
            weatherConditionLabel.text = current.description.capitalized
            weatherIconImage.image = returnIconImage(from: current.icon)
            
        }
        tempLabel.text = "\(Int(currentWeather.temp))°"
    }
    
    @objc fileprivate func handleSegmentChange(){
        forecastCollectionView.reloadData()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchCityVC"{
            let destinationVC = segue.destination as? SearchCityVC
            destinationVC!.delegate = self
        }
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
            NetworkRequest.shared.fetchWeatherData(location: coordinates) { data in
                self.currentWeather = data.current
                
                // only append the next 5 hours to hourlyWeather array
                for hourlyData in data.hourly[1...5]{
                    self.hourlyWeather.append(hourlyData)
                }
                // only append the next 5 days to dailyWeather array
                for dailyData in data.daily[1...5]{
                    self.dailyWeather.append(dailyData)
                }
                
                DispatchQueue.main.async {
                    // TODO: Update UI with weather data
                    self.updateCurrentWeatherUIWith(currentWeather: self.currentWeather!)
                    self.forecastCollectionView.reloadData()
                }
            } onError: { errorMessage in
                // TODO: display error in an alert
                print("PRINT: from getUserCoordinates", errorMessage)
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
            // Show an alert instructing user how to turn on permission
            alertUserToEnableLocationPermission()
            break
        case.notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert instructing user how to turn on permission
            alertUserToEnableLocationPermission()
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
                    self.cityNameLabel.text = placemark.first?.locality!
                }
            }
        }
    }
}

// MARK: - Search City's Weather Delegate
extension WeatherVC: ChangeCityDelegate{
    func userEnteredANewCityName(city: String, coordinates: CLLocationCoordinate2D) {
        NetworkRequest.shared.fetchWeatherData(location: coordinates) { data in
            self.currentWeather = data.current
            self.cityNameLabel.text = city
            
            // clear out hourlyWeather and dailyWeather arrays to append searched city weather data
            self.hourlyWeather.removeAll()
            self.dailyWeather.removeAll()
            
            // only append the next 5 hours to hourlyWeather array
            for hourlyData in data.hourly[1...5]{
                self.hourlyWeather.append(hourlyData)
            }
            // only append the next 5 days to dailyWeather array
            for dailyData in data.daily[1...5]{
                self.dailyWeather.append(dailyData)
            }
            
            DispatchQueue.main.async {
                // Update UI with weather data
                self.updateCurrentWeatherUIWith(currentWeather: self.currentWeather!)
                self.forecastCollectionView.reloadData()
            }
        } onError: { errorMessage in
            print("PRINT: from getUserCoordinates", errorMessage)
        }

    }
    
    

}
// MARK: - CollectionView Delegate and Datasource
extension WeatherVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch forecastSegment.selectedSegmentIndex {
        case 0:
            return CGSize(width: 70, height: 100)
        case 1:
            return CGSize(width: 70, height: 100)
        default:
           return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch forecastSegment.selectedSegmentIndex {
        case 0:
            return hourlyWeather.count
        case 1:
            return dailyWeather.count
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifier, for: indexPath) as! ForecastCollectionViewCell
        switch forecastSegment.selectedSegmentIndex {
        case 0:
            cell.configureHourly(with: hourlyWeather[indexPath.row])
        case 1:
            cell.configureDaily(with: dailyWeather[indexPath.row])
        default:
            break
        }
        
        return cell
    }
}

//MARK: - Error Handling
extension WeatherVC{
    func alertUserToEnableLocationPermission(){
        let ac = UIAlertController(title: "Permission Error", message: "Please enable permissions by going to Settings > Privacy > Clima and select While Using the App", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
