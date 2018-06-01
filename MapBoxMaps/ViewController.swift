//
//  ViewController.swift
//  MapBoxMaps
//
//  Created by Rehan Parkar on 2018-05-31.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation


class ViewController: UIViewController, MGLMapViewDelegate {

    //variables
    var mapView: NavigationMapView!
    var navigateButton: UIButton!
    var directionRoute: Route?
    let disneyCoordinate = CLLocationCoordinate2D(latitude: 33.8121, longitude: -117.9190)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        addButton()
    }

    
    func addButton() {
        navigateButton = UIButton(frame: CGRect(x: (view.frame.width / 2) - 100, y: (view.frame.height) - 75, width: 200, height: 50))
        navigateButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigateButton.setTitle("NAVIGATE", for: .normal)
        navigateButton.setTitleColor(#colorLiteral(red: 0.8274509804, green: 0.2823529412, blue: 0.2117647059, alpha: 1), for: .normal)
        navigateButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        navigateButton.layer.cornerRadius = 20
        navigateButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        navigateButton.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        navigateButton.layer.shadowRadius = 5
        navigateButton.layer.shadowOpacity = 0.3
        
        navigateButton.addTarget(self, action: #selector(navigationButtonPressed(_:)), for: .touchUpInside)
        view.addSubview(navigateButton)
        
        
    }
    
    @objc func navigationButtonPressed(_ sender: UIButton){
        
        mapView.setUserTrackingMode(.none, animated: true)
        let annotation = MGLPointAnnotation()
        annotation.coordinate = disneyCoordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)
        
        
        calculateRoute(from: mapView.userLocation!.coordinate, to: disneyCoordinate) { (route, error) in
            
           
            if error != nil {
                print("error loading route")
            }
        }
    }
    
    func calculateRoute(from originCoOr:CLLocationCoordinate2D, to destinationCoOr: CLLocationCoordinate2D,  completion: @ escaping (Route?, Error?) -> Void) {
        
        let origin = Waypoint(coordinate: originCoOr, coordinateAccuracy: -1, name: "start")
        let destination = Waypoint(coordinate: destinationCoOr, coordinateAccuracy: -1, name: "Finish")
        let option = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        _ = Directions.shared.calculate(option, completionHandler: { (wayPoints, routes, error) in
            
            self.directionRoute = routes?.first

            self.drawRoute(route: self.directionRoute!)
            
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoOr, ne: originCoOr)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCam, animated: true)
            
        })
        
    }
    
    func drawRoute(route: Route) {

        guard route.coordinateCount > 0  else {return}
        var routeCoordinates = route.coordinates!
        let polyLine = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)

        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyLine
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyLine], options: nil)

            let lineStyle = MGLLineStyleLayer(identifier: "route-source", source: source)
            //lineStyle.lineColor = MGLStyleConstantValue(UIColor.blue)
           // lineStyle.lineWidth = MGLStyleConstantValue(4.0)

            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)

        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationVC = NavigationViewController(for: directionRoute!)
        present(navigationVC, animated: true, completion: nil )
    }
    

}

