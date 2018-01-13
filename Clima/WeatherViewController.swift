//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class WeatherViewController: UIViewController {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData(data: JSON, error: Error?) {
        if let error = error {
            fatalError("Error: \(error).")
        }
        
        print(data)
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        return
    }
    
    
    
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            notifyUserOfLocationError(locationError: nil)
            return
        }
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            let latitude =  String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String:String] =  [
                "lat": latitude,
                "lon": longitude,
                "appid": WEATHER_APP_ID
            ]
            
            WeatherManager.fetchWeatherData(withURL: WEATHER_URL, AppID: WEATHER_APP_ID, andParams: params, callback: updateUIWithWeatherData(data:error:))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        notifyUserOfLocationError(locationError: error)
    }
    
    func notifyUserOfLocationError(locationError: Error?) {
        cityLabel.text = "Location Unavailable"
        
        if let error = locationError {
            print("Failed with error: \(error)")
        }
    }
}


