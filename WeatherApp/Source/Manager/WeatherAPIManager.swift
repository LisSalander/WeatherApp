//
//  WeatherAPIManager.swift
//  WeatherApp
//
//  Created by Vika on 7/30/19.
//  Copyright © 2019 Vika. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

enum WeatherAPIRouter  {
    case weather(lat: Double, lon: Double)
}

class WeatherAPIManager: SessionManager {
    
    static var instance = WeatherAPIManager()
    
    func getWeather(coordinator: CLLocationCoordinate2D, completion: @escaping (Weather?, Error?) -> ()) {
        Alamofire.request(getRouter(coordinator: coordinator))
            .validate(statusCode: 200...300)
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let data) :
                    let json = JSON(data)
                    completion(Weather(json: json), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    private func getRouter(coordinator: CLLocationCoordinate2D) -> URLRequestConvertible {
        return WeatherAPIRouter.weather(lat: coordinator.latitude, lon: coordinator.longitude)
    }
}

extension WeatherAPIRouter: ServiceAPIRouter {
    var path: String {
        switch self {
        case .weather(let lat, let lon):
            return "lat=\(lat)&lon=\(lon)&units=metric&APPID=\(Constants.API_KEY)"
        }
    }
}
