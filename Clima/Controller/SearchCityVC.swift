//
//  SearchCityVC.swift
//  Clima
//
//  Created by Joe Vargas on 5/27/21.
//

import UIKit
import CoreLocation

class SearchCityVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    // MARK: Properties
    
    // MARK: App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func searchCityBtnPressed(_ sender: Any) {
        let enteredLocation = searchCityTextField.text
        getLocation(forPlaceCalled: enteredLocation!) { location in
            // TODO: Reverse Geocode entered city name and get coordinates
            guard let city = location?.name else {return}
            guard let latitude = location?.location?.coordinate.latitude else {return}
            guard let longitude = location?.location?.coordinate.longitude else {return}
            print("City: \(city) | Latitude: \(latitude) | Longitude: \(longitude)")
            
            // TODO: Pass coordinates to delegate function
        }

        // Dismiss SearchCityVC
        dismiss(animated: true, completion: nil)
    }
    
    private func getLocation(forPlaceCalled name: String, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            guard error == nil else {
                print("Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("Error in \(#function): placemark is nil")
                completion(nil)
                return
            }

            completion(placemark)
        }
    }
    
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
