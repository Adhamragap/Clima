//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    

   
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherManager = WeatherManager()
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        searchTextField.delegate = self
        weatherManager.delegete = self
       
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    func makeAlert (title: String,message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
   
    
    @IBAction func weatherLocation(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}
//MARK: - UItextFieldDelgete
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cityName = searchTextField.text else {
            return
        }
        weatherManager.fetchWeather(cityName: cityName)
        searchTextField.text = ""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            makeAlert(title: "Ops", message: "please enter city name")
            return false
        }
    }
}
//MARK: - WeatherManagerDelegete
extension WeatherViewController:WeatherManagerDelegete{
    func didUbdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName )
        }
    }
    func didFailedWithError(error: Error) {
        makeAlert(title: "error", message: "\(error)")
    }
}
//MARK: - CLLocationManagerDelegate
extension WeatherViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print ("can't get location")
            return
        }
        let long = location.coordinate.longitude
        let lat = location.coordinate.latitude
       
        weatherManager.fetchWeather(lat:lat,long:long)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
