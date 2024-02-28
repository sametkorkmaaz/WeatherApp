//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Samet Korkmaz on 23.02.2024.
//

import Foundation

struct WeatherModel {
    let aciklamaİD : Int
    let sehir : String
    let derece : Double
    
    var stringDerece : String {
        return String(format: "%.1f", derece)
    }
    
    var sembolAdi : String{
        switch aciklamaİD {
        case 200...232 :
            return "cloud.bolt"
        case 300...321 :
            return "cloud.drizzle"
        case 500...531 :
            return "cloud.rain"
        case 600...622 :
            return "cloud.snow"
        case 701...781 :
            return "cloud.fog"
        case 800 :
            return "sun.max"
        case 801...804 :
            return "cloud.bolt"
        default :
            return "cloud"
            
        }
        
    }
}
