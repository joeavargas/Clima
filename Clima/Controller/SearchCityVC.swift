//
//  SearchCityVC.swift
//  Clima
//
//  Created by Joe Vargas on 5/27/21.
//

import UIKit

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
        // TODO: Reverse Geocode entered city name and get coordinates
        
        // TODO: Pass coordinates to delegate function
        
        // Dismiss SearchCityVC
    }
    
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
