//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Samet Korkmaz on 22.02.2024.
//

// API A İSTEK ATMA VE DÖNÜŞ ALMAK İÇİN

import Foundation
import CoreLocation

// ÖRNEK URL -> https://api.openweathermap.org/data/2.5/weather?q=london&appid=4c179da5520f97fffdbaa4c522f3c2da&units=metric

protocol WeatherManagerDelegate {
   func didUpdateWeather(_ weatherManager : WeatherManager ,weather: WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    
    //ŞEHİR ADI İÇERMEYEN URL
    let weatherUrl =  "https://api.openweathermap.org/data/2.5/weather?&appid=4c179da5520f97fffdbaa4c522f3c2da&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    // URL E ŞEHİR ADI EKLİYORUZ
    func urlSehirEkle(sehiradi : String) {
        
        let sehirliURL = "\(weatherUrl)&q=\(sehiradi)"
        performRequest(with: sehirliURL)
    }
    func urlKonumEkle(enlem : CLLocationDegrees, boylam: CLLocationDegrees ) {
        let konumluURL = "\(weatherUrl)&lat=\(enlem)&lon=\(boylam)"
        performRequest(with: konumluURL)
    }
    
    
    // 4 ADIMDA GERÇEKLEŞİCEK TAlet adımları
    func performRequest(with urlString : String) {
        
        // 1.ADIM URL OLUŞTURMA. String halindeki url i URL yapıyoruz
        if let url = URL(string: urlString){
            
            // 2.ADIM URL OTURUMU OLUŞTURMA -> URLSession
            let session = URLSession(configuration: .default)
            
            // 3.ADIM OTURUMA GÖREVİNİ VERECEGİZ
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil { // eğer hata var ise
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4.ADIM GÖREVİ BAŞLATMA
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let islenmisData = try  decoder.decode(WeatherData.self, from: weatherData)
            
            let sehir = islenmisData.name
            let derece = islenmisData.main.temp
            let sembolID = islenmisData.weather[0].id
            
            let weather = WeatherModel(aciklamaİD: sembolID, sehir: sehir, derece: derece)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

        
        
    }
