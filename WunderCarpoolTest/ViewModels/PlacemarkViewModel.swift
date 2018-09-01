//
//  PlacemarkViewModel.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 29/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PlacemarkViewModel{
  
    var nameString: String = ""
    var addressString: String = ""
    var engineTypeString: String = ""
    var fuel: String = ""
    var lattitude: Double = 0.0
    var longitude: Double = 0.0
    var exteriorImage: UIImage?
    var interiorImage: UIImage?
    var carAnnotation: CarAnnotation?
    
    //UNACCEPTABLE/GOOD

    var data: Placemark {
        didSet {
            nameString = data.name ?? ""
            addressString = data.address ?? ""
            engineTypeString = "Engine type: " + "\(data.engineType ?? "")"
            fuel = "Fuel: " + "\(data.fuel ?? 0)"
            longitude = data.coordinates?[0] ?? 0.0
            lattitude = data.coordinates?[1] ?? 0.0

            let carCorinates = CLLocationCoordinate2DMake(lattitude, longitude)
            carAnnotation = CarAnnotation(coordinate: carCorinates, title: nameString, subTitle: addressString)
//            if data.exterior == "GOOD"{
//                exteriorImage = UIImage.init(named: "")
//            }else{
//                exteriorImage = UIImage.init(named: "")
//            }
//
//            if data.interior == "GOOD"{
//                interiorImage = UIImage.init(named: "")
//            }else{
//                interiorImage = UIImage.init(named: "")
//            }
        }
    }
    
    init(placemarkData: Placemark) {
        self.data = placemarkData
        defer {
            self.data = placemarkData
        }
    }
}
