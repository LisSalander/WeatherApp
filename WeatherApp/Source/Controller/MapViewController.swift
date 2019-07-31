//
//  ViewController.swift
//  WeatherApp
//
//  Created by Vika on 7/29/19.
//  Copyright © 2019 Vika. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationView: UIView?
    @IBOutlet weak var weatherButton: UIButton!
    
    private var mapProtocol: MapProtocol?
    private var mapRegion: CLLocationCoordinate2D?
    
    //  MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initiateView()
        if !Connectivity.isConnectedToInternet {
            showAlert(title: Constants.AlertTexts.error, message: "No internet connection")
        }
    }
    
    //  MARK: - Preparations
    private func initiateView() {
        mapView?.showsUserLocation = true
        
        mapProtocol = MapManager()
        mapProtocol?.delegate = self
        mapProtocol?.getMapAuthorization()
        
        weatherButton.layer.cornerRadius = 10
    }

    // MARK: - Actions
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = .darkGray
        searchController.searchBar.tintColor = .white
        
        present(searchController, animated: true, completion: nil)
    }
 
    @IBAction func weatherButton(_ sender: Any) {
        self.mapRegion = self.mapView?.region.center
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let weatherVC = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController, let mapRegion = self.mapRegion {
            weatherVC.setMapRegion(mapRegion)
            self.navigationController?.pushViewController(weatherVC, animated: true)
        }   
    }
}

//  MARK: - MapDelegate
extension MapViewController: MapDelegate {
    func locationUpdated(to location: CLLocation) {
        let region = MKCoordinateRegion(center: getLocationCoordinator(from: location), span: getLocationSpan())
        self.mapView?.setRegion(region, animated: true)
    }
    
    private func getLocationSpan() -> MKCoordinateSpan {
        return MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    }

    private func getLocationCoordinator(from location: CLLocation) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

//  MARK: - UISearchBar
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()

        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            UIApplication.shared.endIgnoringInteractionEvents()
            if response != nil {
                if let latitude = response?.boundingRegion.center.latitude,
                    let longitude = response?.boundingRegion.center.longitude {
                    self.mapView.region.center = CLLocationCoordinate2DMake(latitude, longitude)
                }
            }
        }
        
    }
}

