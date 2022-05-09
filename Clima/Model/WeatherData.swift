//
//  WeatherData.swift
//  Clima
//
//  Created by adham ragap on 04/05/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData: Codable {
    let name: String
    let weather : [Weather]
    let main : Main
}
struct Weather: Codable {
    let description: String
    let id: Int
}
struct Main: Codable{
let temp:Double
}
