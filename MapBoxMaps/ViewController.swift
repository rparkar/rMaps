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
    var MapView: NavigationMapView!
    var navigateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapView = NavigationMapView(frame: view.bounds)
        MapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(MapView)
        
        MapView.delegate = self
        MapView.showsUserLocation = true
        MapView.setUserTrackingMode(.follow, animated: true)
        
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
        
    }
    
    

}

