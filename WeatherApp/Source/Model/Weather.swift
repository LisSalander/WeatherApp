//
//  Weather.swift
//  WeatherApp
//
//  Created by Vika on 7/30/19.
//  Copyright © 2019 Vika. All rights reserved.
//

import SwiftyJSON

struct Weather {
    let id: Int?
    let weather: String?
    let cityName: String?
    let temp: Int?
    let tempMin: Int?
    let tempMax: Int?
    let humidity: Int?
    let pressure: Int?
    let wind: Double?
    
    init?(json: JSON) {
        id = json["id"].int
        cityName = json["name"].string
        temp = json["main"]["temp"].int
        tempMax = json["main"]["temp_max"].int
        tempMin = json["main"]["temp_min"].int
        humidity = json["main"]["humidity"].int
        pressure = json["main"]["pressure"].int
        wind = json["wind"]["speed"].double
        weather = Weather.convertWeatherString(weather: json["weather"].array)
    }
    
    private static func convertWeatherString(weather: [JSON]?) -> String {
        let weathers = weather?.compactMap {
            return $0["main"].string
        }
        guard let stringWeather = weathers?.joined(separator: ",") else { return "" }
        
        return stringWeather
    }
}
