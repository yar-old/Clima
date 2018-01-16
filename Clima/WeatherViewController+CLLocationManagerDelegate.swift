//
//  WeatherViewController+CLLocationManagerDelegate.swift
//  Clima
//
//  Created by Yuri Ramocan on 1/13/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

//MARK: - Location Manager Delegate Methods
/***************************************************************/

extension WeatherViewController: CLLocationManagerDelegate {
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
            
            WeatherManager.fetchWeatherData(withURL: WEATHER_URL, AppID: WEATHER_APP_ID, andParams: params, completion: { (data, error) in
                self.updateWeather(data: data, error: error)
            })
        }
    }
    
    func updateWeather(data: JSON, error: Error?) {
        do {
            try WeatherManager.updateWeatherData(json: data, weatherModel: self.weatherDataModel)
        } catch WeatherDataError.invalidJSON {
            print("Error: Incorrect JSON data.\nData:\n\(data)")
            self.cityLabel.text = "Could not retrieve weather."
            return
        } catch {
            print("Unknown Error: Could not update weather data.")
            self.cityLabel.text = "Could not retrieve weather."
            return
        }
        
        self.updateUIWithWeatherData()
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
