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
import os

class WeatherManager {
    static func fetchWeatherData(withURL url: String, AppID appID: String, andParams params: [String:String], callback: @escaping (_ data: JSON, _ error: Error?) -> Void) {
        Alamofire.request(url, method: .get, parameters: params)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("\(response.result.error.debugDescription)")
                    callback(JSON.null, WeatherDataError.badServerResponse)
                    return
                }
                
                guard let json = response.result.value else {
                    print("JSON ERROR: \(response.result.error.debugDescription)")
                    callback(JSON.null, WeatherDataError.invalidJSON)
                    return
                }
                
                callback(JSON(json), nil)
        }
    }
}

enum WeatherDataError: Error {
    case invalidJSON
    case badServerResponse
}
