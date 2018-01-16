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
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"

    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData() {
        temperatureLabel.text = "\(weatherDataModel.tempF())"
        cityLabel.text = "\(weatherDataModel.city)"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let changeCityVC = segue.destination as! ChangeCityViewController
            changeCityVC.delegate = self
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

//MARK: - Change City VC Delegate Methods
/***************************************************************/

extension WeatherViewController: ChangeCityViewControllerDelegate {
    func userEnteredANewCityName(_ city: String) {
        let params = [ "q": city, "appid": WEATHER_APP_ID ]
        
        WeatherManager.fetchWeatherData(withURL: WEATHER_URL, AppID: WEATHER_APP_ID, andParams: params, completion: { (data, error) in
            self.updateWeather(data: data, error: error)
        })
    }
}
