//
//  WeatherData.swift
//  Meteo Kraze iOS
//
//  Created by Guillaume Fourrier on 13/09/2018.
//  Copyright © 2018 Guillaume Fourrier. All rights reserved.
//

import Foundation

struct WeatherData {
    var cityName: String
    var temp: Int
    var tempMax: Int
    var tempMin: Int
    var humidity: Int
    var wind: Float
    var sunrise: Double
    var sunset: Double
    var isCurrent: Bool
    var description: String
}
