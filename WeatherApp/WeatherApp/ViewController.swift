//
//  ViewController.swift
//  WeatherApp
//
//  Created by Samet Korkmaz on 20.02.2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
  
    @IBOutlet weak var aramaTextField: UITextField!
    @IBOutlet weak var havaDurumuImage: UIImageView!
    @IBOutlet weak var dereceLabel: UILabel!
    @IBOutlet weak var SehirLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let konumManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        konumManager.delegate = self
        konumManager.requestWhenInUseAuthorization() // izin isteme
        konumManager.requestLocation()  // konumu bulma
        
        weatherManager.delegate = self
    }
    
    @IBAction func konumluHaaDurumu(_ sender: UIButton) {
        konumManager.requestLocation() // butona basınca konumu tekrar alıyoruz
    }
    
}
// MARK: WeatherManagerDelegate
//bu şekilde de yapabiliriz direkt viewConroller a , koyup kalıtım vererekte
extension ViewController : WeatherManagerDelegate {
    
    @IBAction func aramaButton(_ sender: Any) {
        
        if let sehir = aramaTextField.text {
            weatherManager.urlSehirEkle(sehiradi: sehir)
        }
        aramaTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager : WeatherManager ,weather: WeatherModel){
        DispatchQueue.main.async {
            self.dereceLabel.text = weather.stringDerece + "°C"
            self.SehirLabel.text = weather.sehir
            self.havaDurumuImage.image = UIImage(systemName: weather.sembolAdi)
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

// MARK: CoreLocation
extension ViewController : CLLocationManagerDelegate { // KONUMU ALIR
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            konumManager.stopUpdatingLocation()
            let enlem = location.coordinate.latitude
            let boylam = location.coordinate.longitude
            
            weatherManager.urlKonumEkle(enlem: enlem, boylam: boylam)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) // KONUM ALINIRKEN HATA OLURSA
    }
}
