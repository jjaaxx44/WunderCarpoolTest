//
//  Extentions.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 30/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MKMapView
{
    func hideAnnotations(exception : MKAnnotation) {
        for annotation in annotations {
            if !exception.isEqual(annotation){
                view(for: annotation)?.isHidden = true
            }
        }
    }
    func unHideAllAnnotations() {
        for annotation in annotations {
            view(for: annotation)?.isHidden = false
        }
    }
    
    func fitAllMarkers(shouldIncludeCurrentLocation: Bool, annotationsToFit: [MKAnnotation] = []) {
        
        if !shouldIncludeCurrentLocation{
            (annotationsToFit.count == 0) ? showAnnotations(annotations, animated: true) : showAnnotations(annotationsToFit, animated: true)
        }else {
            var zoomRect = MKMapRectNull
            
            let point = MKMapPointForCoordinate(userLocation.coordinate)
            let pointRect = MKMapRectMake(point.x, point.y, 0, 0)
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
            
            let listOfAnnotations = (annotationsToFit.count == 0) ? annotations : annotationsToFit
            
            for annotation in listOfAnnotations {
                
                let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
                let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
                
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
            }
            
            setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(8, 8, 8, 8), animated: true)
        }
    }
}
