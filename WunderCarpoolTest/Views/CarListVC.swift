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

    @IBOutlet weak var carMapView: MKMapView!
    @IBOutlet weak var carsTableView: UITableView!
    var carsList: [PlacemarkViewModel]?
    
    @IBOutlet weak var viewToggelSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewToggled(viewToggelSegmentControl)
        
        carsTableView.register(UINib(nibName: "CarTableCell", bundle: nil), forCellReuseIdentifier: "CarTableCellIdentifier")

        CarListFetcher.shared.FetchCars { (carList, result) in
            self.carsList = carList
            DispatchQueue.main.async {
                self.carsTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            carsTableView.isHidden = false
            carMapView.isHidden = true
        }else{
            carsTableView.isHidden = true
            carMapView.isHidden = false
        }
    }
}

extension CarListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableCellIdentifier", for: indexPath) as! CarTableCell
        
        let carModelView = carsList![indexPath.row]
        cell.carModelView =  carModelView
        return cell
    }
}
