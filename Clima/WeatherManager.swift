//
//  WeatherManager.swift
//  Clima
//
//  Created by Yuri Ramocan on 1/13/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherManager {
    static func fetchWeatherData(withURL url: String, AppID appID: String, andParams params: [String:String], completion: @escaping (_ data: JSON, _ error: Error?) -> Void) {
        Alamofire.request(url, method: .get, parameters: params)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("\(response.result.error.debugDescription)")
                    completion(JSON.null, WeatherDataError.badServerResponse)
                    return
                }
                
                guard let json = response.result.value else {
                    print("JSON ERROR: \(response.result.error.debugDescription)")
                    completion(JSON.null, WeatherDataError.invalidJSON)
                    return
                }
                
                completion(JSON(json), nil)
        }
    }
    
    static func updateWeatherData(json: JSON, weatherModel: WeatherDataModel) throws {
        guard let temperature = json["main"]["temp"].double,
              let condition = json["weather"][0]["id"].int,
              let city = json["name"].string else {
            throw WeatherDataError.invalidJSON
        }
        
        weatherModel.temperature = temperature
        weatherModel.condition = condition
        weatherModel.city = city
        weatherModel.weatherIconName = weatherModel.updateWeatherIcon(condition: condition)
    }
    
}

enum WeatherDataError: Error {
    case invalidJSON
    case badServerResponse
}
