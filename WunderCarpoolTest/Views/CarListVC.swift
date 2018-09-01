//
//  CarListVC.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 29/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import UIKit
import MapKit

class CarListVC: UIViewController {
    
    let locationManager = CLLocationManager()
    let carReuseIdentifier = "CarReuseIdentifier"
    
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var carMapView: MKMapView!
    @IBOutlet weak var carsTableView: UITableView!
    @IBOutlet weak var viewToggelSegmentControl: UISegmentedControl!
    
    var carsList: [PlacemarkViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkLocationAuthorizationStatus()
        
        viewToggled(viewToggelSegmentControl)
        
        carsTableView.register(UINib(nibName: "CarTableCell", bundle: nil), forCellReuseIdentifier: "CarTableCellIdentifier")
        
        carMapView.register(CarAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        CarListFetcher.shared.FetchCars { (carList, result) in
            self.carsList = carList
            for car in self.carsList{
                guard let carAnnotation = car.carAnnotation else{
                    return
                }
                self.carMapView.addAnnotation(carAnnotation)
            }
            DispatchQueue.main.async {
                self.carsTableView.reloadData()
                self.carMapView.fitAllMarkers(shouldIncludeCurrentLocation: false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            carMapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    @IBAction func showAllClicked(_ sender: Any) {
        self.carMapView.fitAllMarkers(shouldIncludeCurrentLocation: false)
    }
    
    @IBAction func viewToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            carsTableView.isHidden = false
            mapContainer.isHidden = true
        }else{
            carsTableView.isHidden = true
            mapContainer.isHidden = false
        }
    }
}

extension CarListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableCellIdentifier", for: indexPath) as! CarTableCell
        
        let carModelView = carsList[indexPath.row]
        cell.carModelView =  carModelView
        return cell
    }
}

extension CarListVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        print("annotation view disclouser clicked!!")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if userLocation.isUpdating {
            return
        }else{
            self.carMapView.fitAllMarkers(shouldIncludeCurrentLocation: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if !(view.annotation is MKClusterAnnotation){
            mapView.unHideAllAnnotations()
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKClusterAnnotation{
            guard let annotations = (view.annotation as? MKClusterAnnotation)?.memberAnnotations else{
                return
            }
            mapView.fitAllMarkers(shouldIncludeCurrentLocation: false, annotationsToFit: annotations)
        }else{
            guard let annotation = view.annotation else{
                return
            }
            mapView.hideAnnotations(exception: annotation)
        }
    }
}
