//
//  CarAnnotation.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 30/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import UIKit
import MapKit

class CarAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subTitle: String?
    init(coordinate: CLLocationCoordinate2D, title: String?, subTitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subTitle = subTitle
        super.init()
    }
}

