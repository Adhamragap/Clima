//
//  WeatherManager.swift
//  Clima
//
//  Created by adham ragap on 03/05/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
protocol WeatherManagerDelegete {
    func didUbdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel)
    func didFailedWithError(error:Error)
}
struct WeatherManager {
    var delegete : WeatherManagerDelegete?
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=05be76f938a7f578754c13799df298ec&units=metric"
   
    func fetchWeather (cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
       
    }
   func fetchWeather(lat:Double,long:Double) {
       let url = "\(weatherUrl)&lat=\(lat)&lon=\(long)"
       performRequest(with: url)
    }
    
    func performRequest (with url:String){
        guard let url = URL(string: url) else {
            print("error with url")
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                self.delegete?.didFailedWithError(error: error)
                return 
            }
            guard let safeData = data else {
                return
            }
            guard let weather =  self.parseJson(safeData) else {return}
            delegete?.didUbdateWeather(self ,weather: weather)
            
            
        }
        task.resume()
    }
    func parseJson (_ weatherData:Data) -> WeatherModel?{
            do {
                let decoder = JSONDecoder()
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
             let weatherId = decodedData.weather[0].id
             let name = decodedData.name
             let temp = decodedData.main.temp
             let weather = WeatherModel(conditionID: weatherId, cityName: name, temperature: temp)
             return weather
                
            }catch{
                print("error decoding data \(error)")
                delegete?.didFailedWithError(error: error)
                return nil
            
        }
    }
    
}
