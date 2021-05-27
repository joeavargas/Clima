//
//  SearchCityVC.swift
//  Clima
//
//  Created by Joe Vargas on 5/27/21.
//

import UIKit
import CoreLocation

protocol ChangeCityDelegate{
    func userEnteredANewCityName(city: String, coordinates: CLLocationCoordinate2D)
}

class SearchCityVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    // MARK: Properties
    var delegate: ChangeCityDelegate?
    
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
            guard let coordinates = location?.location?.coordinate else {return}
            
            // TODO: Pass coordinates to delegate function
            self.delegate?.userEnteredANewCityName(city: city, coordinates: coordinates)
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
