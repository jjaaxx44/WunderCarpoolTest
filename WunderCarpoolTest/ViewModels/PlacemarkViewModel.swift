//
//  PlacemarkViewModel.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 29/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import Foundation
import UIKit
class PlacemarkViewModel{
    var data: Placemark {
        didSet {
            nameString = data.name ?? ""
            addressString = data.address ?? ""
            engineTypeString = "Engine type: " + "\(data.engineType ?? "")"
            fuel = "Fuel: " + "\(data.fuel ?? 0)"
            lattitude = data.coordinates?[0] ?? -1
            longitude = data.coordinates?[1] ?? -1
            
            if data.exterior == "GOOD"{
                exteriorImage = UIImage.init(named: "")
            }else{
                exteriorImage = UIImage.init(named: "")
            }

            if data.interior == "GOOD"{
                interiorImage = UIImage.init(named: "")
            }else{
                interiorImage = UIImage.init(named: "")
            }
        }
    }
    
    var nameString: String?
    var addressString: String?
    var engineTypeString: String?
    var fuel: String?
    var lattitude: Double?
    var longitude: Double?
    var exteriorImage: UIImage?
    var interiorImage: UIImage?
    
    //UNACCEPTABLE/GOOD
    
    init(placemarkData: Placemark) {
        self.data = placemarkData
        defer {
            self.data = placemarkData
        }
    }
}
