//
//  CarAnnotationView.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 30/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import Foundation
import MapKit



class CarAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        didSet {
            guard let carAnnotaion = annotation as? CarAnnotation else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)

//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setImage(UIImage(named: "direction"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton

            displayPriority = .required
            
            image = UIImage(named: "custompin")
            
            let addressLabel = UILabel()
            addressLabel.numberOfLines = 0
            addressLabel.font = addressLabel.font.withSize(12)
            addressLabel.text = carAnnotaion.subTitle
            detailCalloutAccessoryView = addressLabel
            
            clusteringIdentifier = "cluster"
        }
    }
}
