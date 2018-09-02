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
    func showRouteInApp(destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        showAnnotations([destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        // Calculate direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                print("Error: \(String(describing: error))")
                return
            }
            
            if response.routes.count == 0{
                return
            }
            
            let route = response.routes[0]
            
            self.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let mapRect = route.polyline.boundingMapRect
            self.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsetsMake(10, 10, 10, 10), animated: true)

        }
    }

    func hideAnnotations(exception : MKAnnotation) {
        for annotation in annotations {
            if annotation is MKUserLocation{
                continue
            }
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
            (annotationsToFit.count == 0) ? showAnnotations(annotations, animated: true) : showAnnotations(annotationsToFit, animated: false)
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
            
            setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(10, 10, 10, 10), animated: false)
        }
    }
}
