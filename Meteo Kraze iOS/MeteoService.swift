//
//  MeteoService.swift
//  Meteo Kraze iOS
//
//  Created by Guillaume Fourrier on 13/09/2018.
//  Copyright © 2018 Guillaume Fourrier. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MeteoService {
    
    static let shared = MeteoService()
    private let apiKey = "4271a4992f162462f555468b8aa580f2"
    
    var cities = [WeatherData]()
    
    func getWeahter(city: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=" + apiKey
        Alamofire.request(url).responseJSON { response in
            do {
                guard response.data != nil else {
                    return
                }
                let json = try JSON(data: response.data!)
                self.parseResponse(json: json)
            } catch {
                print("Guillaume - Error parsing JSON")
            }
            
        }
    }
    
    func getWeather(lat: Float, lon: Float) {
        let url = "http://api.openweathermap.org/data/2.5/weather?lat="
            + String(lat) + "&lon=" + String(lon) + "&appid=" + apiKey
        Alamofire.request(url).responseJSON { response in
            do {
                guard response.data != nil else {
                    return
                }
                let json = try JSON(data: response.data!)
                self.parseResponse(json: json)
            } catch {
                print("Guillaume - Error parsing JSON")
            }
            
        }
    }
    
    func parseResponse(json: JSON) {
        guard let cityName = json["name"].string else { return }
        guard let description = json["weather"][0]["description"].string else { return }
        guard let humidity = json["main"]["humidity"].int else { return }
        guard let temp = json["main"]["temp"].int else { return }
        guard let tempMax = json["main"]["temp_max"].int else { return }
        guard let tempMin = json["main"]["temp_min"].int else { return }
        guard let wind = json["wind"]["speed"].float else { return }
        guard let sunrise = json["sys"]["sunrise"].int64 else { return }
        guard let sunset = json["sys"]["sunset"].int64 else { return }
        
        let data = WeatherData(cityName: cityName,
                               temp: temp,
                               tempMax: tempMax,
                               tempMin: tempMin,
                               humidity: humidity,
                               wind: wind,
                               sunrise: sunrise,
                               sunset: sunset,
                               isCurrent: false,
                               description: description)
        self.cities.append(data)
    }
    
}
