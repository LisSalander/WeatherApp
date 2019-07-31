//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Vika on 7/30/19.
//  Copyright © 2019 Vika. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: BaseViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    
    private var mapRegion: CLLocationCoordinate2D?
    private var weather: Weather?
    
    //  MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        cleanViews()
        if !Connectivity.isConnectedToInternet {
            showAlert(title: Constants.AlertTexts.error, message: "No internet connection")
        } else {
            activityIndicator(active: true)
            loadWeather()
        }
    }
    
    //  MARK: - Setters
    func setMapRegion(_ mapRegion: CLLocationCoordinate2D) {
        self.mapRegion = mapRegion
    }

    //  MARK: - Preparations
    func updateUI() {
        weatherView.isHidden = false
        cityLabel.text = weather?.cityName ?? ""
        tempLabel.text = "\(weather?.temp ?? 0)°"
        weatherLabel.text = weather?.weather ?? ""
        humidityLabel.text = "\(weather?.humidity ?? 0)%"
        windLabel.text = "\(weather?.wind ?? 0)m/s"
        pressureLabel.text = "\(weather?.pressure ?? 0)hPa"
        switch weather?.weather {
        case "Sun", "Clear":
            weatherImage.image = UIImage(named: "sun")
        case "Rain", "Drizzle":
            weatherImage.image = UIImage(named: "rain")
        case "Clouds", "Haze", "Mist", "Fog":
            weatherImage.image = UIImage(named: "сloudy")
        case "Snow":
            weatherImage.image = UIImage(named: "snow")
        case "Extreme", "Thunderstorm":
            weatherImage.image = UIImage(named: "thunder")

        default:
            return
        }
    }
    
    private func cleanViews() {
        cityLabel.text = ""
        tempLabel.text = ""
        weatherLabel.text = ""
        weatherView.isHidden = true
    }
    
    // MARK: - Network
    func loadWeather() {
        guard let mapRegion = mapRegion else { return }
        WeatherAPIManager.instance.getWeather(coordinator: mapRegion) { [weak self] (weather, error) in
            self?.activityIndicator(active: false)
            guard let weather = weather else { return }
            self?.weather = weather
            if let error = error{
                self?.showAlert(error: error)
            } else {
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
        }
    }
}
