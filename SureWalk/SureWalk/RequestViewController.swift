//
//  RequestViewController.swift
//  SureWalk
//
//  Created by Vaidehi Duraphe on 3/20/17.
//  Copyright © 2017 Vaidehi Duraphe. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RequestViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    enum MapType: NSInteger {
        case StandardMap = 0
        case SatelliteMap = 1
        case HybridMap = 2
    }
    
    var locationManager = CLLocationManager.init()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        locationManager.requestWhenInUseAuthorization()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        // Do any additional setup after loading the view.
    }

    @IBAction func currentLocation(_ sender: UIBarButtonItem) {
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
        mapView.setRegion(region, animated: true)
    }
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case MapType.StandardMap.rawValue:
            mapView.mapType = .standard
        case MapType.SatelliteMap.rawValue:
            mapView.mapType = .satellite
        case MapType.HybridMap.rawValue:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView .setCenter(userLocation.coordinate, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
