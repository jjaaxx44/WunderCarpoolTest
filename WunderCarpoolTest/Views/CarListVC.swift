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
    var filteredCarsList = [PlacemarkViewModel]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var firstLoacationUpdateDone: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkLocationAuthorizationStatus()
        
        setupUI()
        
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
    
    private func setupUI(){
        title = "Wunder Cars"
        viewToggled(viewToggelSegmentControl)
        
        carsTableView.register(UINib(nibName: "CarTableCell", bundle: nil), forCellReuseIdentifier: "CarTableCellIdentifier")
        
        carMapView.register(CarAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search place, car, pin"
        navigationItem.searchController = searchController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            carMapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    @IBAction func showAllClicked(_ sender: Any) {
        carMapView.removeOverlays(carMapView.overlays)
        carMapView.unHideAllAnnotations()
        
        searchController.isActive = false
        searchController.searchBar.text = ""
        
        carMapView.removeAnnotations(carMapView.annotations)
        for car in self.carsList{
            guard let carAnnotation = car.carAnnotation else{
                return
            }
            self.carMapView.addAnnotation(carAnnotation)
        }
        
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
    
    private func showDirectionInMapAPP(annotationView view: MKAnnotationView){
        guard let latitude = view.annotation?.coordinate.latitude else{
            return
        }
        guard let longitude = view.annotation?.coordinate.longitude else{
            return
        }
        let directionsURL = API.APPLE_DIRECTION_URL + "\(latitude),\(longitude)"
        guard let url = URL(string: directionsURL) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func showDirectionWithinAPP(annotationView view: MKAnnotationView){
        guard let coordinate = view.annotation?.coordinate else{
            return
        }
        
        carMapView.removeAnnotations(carMapView.annotations)
        
        carMapView.showRouteInApp(destinationCoordinate: coordinate)
    }
}

extension CarListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching(){
            return filteredCarsList.count
        }
        return carsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableCellIdentifier", for: indexPath) as! CarTableCell
        
        let carModelView: PlacemarkViewModel
        
        if isSearching(){
            carModelView = filteredCarsList[indexPath.row]
        }else{
            carModelView = carsList[indexPath.row]
        }
        cell.carModelView =  carModelView
        
        return cell
    }
}

extension CarListVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredCarsList = carsList.filter({( car : PlacemarkViewModel) -> Bool in
            
            if isSearchBarEmpty() {
                return true
            } else {
                return car.addressString.lowercased().contains(searchController.searchBar.text!.lowercased()) || car.nameString.lowercased().contains(searchController.searchBar.text!.lowercased())
            }
        })
        carsTableView.reloadData()
        
        if !isSearchBarEmpty() {
            carMapView.removeAnnotations(carMapView.annotations)
            let listOfCars = isSearching() ? self.filteredCarsList : carsList
            
            for car in listOfCars{
                guard let carAnnotation = car.carAnnotation else{
                    return
                }
                self.carMapView.addAnnotation(carAnnotation)
            }
        }
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && (!isSearchBarEmpty())
    }
    
}
extension CarListVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        let directionOptions: UIAlertController = UIAlertController(title: "Direction", message: "How would you like us to show directions", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
            directionOptions.dismiss(animated: true, completion: nil)
        }
        directionOptions.addAction(cancelActionButton)
        
        let inAppButton = UIAlertAction(title: "Within app", style: .default)
        { _ in
            self.showDirectionWithinAPP(annotationView: view)
        }
        directionOptions.addAction(inAppButton)
        
        let inMapAppButton = UIAlertAction(title: "In maps application", style: .default)
        { _ in
            self.showDirectionInMapAPP(annotationView: view)
        }
        directionOptions.addAction(inMapAppButton)
        
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true) { () -> Void in
                self.present(directionOptions, animated: true, completion: nil)
            }
        }else{
            self.present(directionOptions, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if userLocation.isUpdating {
            return
        }else{
            if firstLoacationUpdateDone == false{
                self.carMapView.fitAllMarkers(shouldIncludeCurrentLocation: true)
                firstLoacationUpdateDone = true
            }
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3.0
        return renderer
    }
    
}
