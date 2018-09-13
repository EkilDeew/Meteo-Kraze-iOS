//
//  ViewController.swift
//  Meteo Kraze iOS
//
//  Created by Guillaume Fourrier on 12/09/2018.
//  Copyright © 2018 Guillaume Fourrier. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var cityTableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
        
        MeteoService.shared.cities.asObservable()
            .subscribe(onNext: { updatedArray in
                self.refresh()
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCityButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MeteoService.shared.cities.value.count == 0 {
            determineMyCurrentLocation()
        }
    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            MeteoService.shared.getWeather(lat: location.coordinate.latitude,
                                           lon: location.coordinate.longitude)
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func refresh() {
        if MeteoService.shared.cities.value.count > 0 {
            loadingLabel.isHidden = true
            loadingSpinner.isHidden = true
            cityTableView.isHidden = false
            
            if !MeteoService.shared.cities.value[0].isCurrent {
                for city in MeteoService.shared.cities.value {
                    if city.isCurrent {
                        removeCurrentPosFromArray()
                        MeteoService.shared.cities.value.insert(city, at: 0)
                        
                    }
                }
            }
            self.cityTableView.reloadData()
        } else {
            loadingLabel.isHidden = false
            loadingSpinner.isHidden = false
            cityTableView.isHidden = true
        }
    }
    
    func removeCurrentPosFromArray() {
        var i = 0
        while i < MeteoService.shared.cities.value.count {
            if MeteoService.shared.cities.value[i].isCurrent == true {
                MeteoService.shared.cities.value.remove(at: i)
                return
            }
            i = i + 1
        }
    }
    
    @objc func addCityButton() {
        let addCityController = self.storyboard?.instantiateViewController(withIdentifier: "AddCity") as! AddCityViewController
        
        self.navigationController?.pushViewController(addCityController, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MeteoService.shared.cities.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = MeteoService.shared.cities.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as! CityCell
        
        cell.cityNameLabel.text = city.cityName
        if city.isCurrent == true {
            cell.currentPosLabel.isHidden = false
        } else {
            cell.currentPosLabel.isHidden = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        cell.mainTempLabel.text = String(city.temp - 273) + "°C"
        cell.descriptionLabel.text = city.description
        
        let sunriseDate = Date(timeIntervalSince1970: city.sunrise)
        let sunsetDate = Date(timeIntervalSince1970: city.sunset)
        cell.sunriseLabel.text = "Sunrise : " + dateFormatter.string(from: sunriseDate)
        cell.sunsetLabel.text = "Sunset : " + dateFormatter.string(from: sunsetDate)
        
        cell.maxTempLabel.text = "Max : " + String(city.tempMax - 273) + "°C"
        cell.minTempLabel.text = "Min : " + String(city.tempMin - 273) + "°C"
        
        cell.windLabel.text = "Wind : " + String(city.wind) + " m/s"
        cell.humidityLabel.text = "Humidity : " + String(city.humidity) + "%"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if MeteoService.shared.cities.value[indexPath.row].isCurrent == false {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            MeteoService.shared.cities.value.remove(at: indexPath.row)
        }
    }
 
}

