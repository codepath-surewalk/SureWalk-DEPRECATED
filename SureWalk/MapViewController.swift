//
//  MapViewController.swift
//  Photo Map
//
//  Created by SureWalk Team on 5/11/2017.
//  Copyright © 2017 SureWalk Team. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MapViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placesView: UIView!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    var imageToView: UIImage!
    var locationManager = CLLocationManager.init()
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    @IBOutlet weak var destinationPin: UIImageView!
    @IBOutlet weak var locationPin: UIImageView!
    
    @IBOutlet weak var currentLocationButton: UIBarButtonItem!
    
    var locationCoord = CLLocationCoordinate2D()
    var destinationCoord = CLLocationCoordinate2D()
    var userCoord = CLLocationCoordinate2D()
    
    var locLocked = false
    var destChosen = false
    
    enum MapType: NSInteger {
        case StandardMap = 0
        case SatelliteMap = 1
        case HybridMap = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient_SUREWalk.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_SUREWalk.jpg")!)
        
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = ""
        
        mapView.delegate = self

        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        
        locationTextField.delegate = self
        setTextField(textField: locationTextField, coord: userCoord)
        
        destinationTextField.delegate = self
        
        hidePins(location: false, destination: true)
        
        placesView.layer.cornerRadius = 6
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        mapView.addGestureRecognizer(panRecognizer)
        panRecognizer.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.startUpdatingLocation()
            userCoord = (manager.location?.coordinate)!
            mapView.region = MKCoordinateRegionMakeWithDistance(userCoord, 10, 10)
        }
        else if status == CLAuthorizationStatus.denied {
            userCoord = CLLocationCoordinate2D(latitude: 30.286109, longitude: -97.739426) // Default the location to UT Tower
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userCoord = (manager.location?.coordinate)!
    }
    
    func didPan(sender: UIPanGestureRecognizer) {
        movedMap()
    }
    
    func movedMap() {
        if !locLocked && !destChosen {
            hidePins(location: false, destination: true)
            
            locationCoord = mapView.centerCoordinate
            
            setTextField(textField: locationTextField, coord: locationCoord)
            
            removeAnnotations(named: "Location")
        }
    }
    
    // Mark: – LocationsViewControllerDelegate
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber, name: String, locDest: String) {
        
        if locDest == "loc" {
            locLocked = false
            locationCoord = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            
            setTextField(textField: locationTextField, coord: locationCoord, name: name)
            
            mapView.region = MKCoordinateRegionMakeWithDistance(locationCoord, 150, 150)
            
            replaceAnnotation(named: "Location")
            
        } else {
            locLocked = true
            destChosen = true
            currentLocationButton.isEnabled = false
            destinationCoord = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            
            setTextField(textField: destinationTextField, coord: destinationCoord, name: name)
            
            mapView.region = MKCoordinateRegionMakeWithDistance(destinationCoord, 150, 150)
            
            replaceAnnotation(named: "Destination")
        }
        
        if destChosen {
            setFullRegion()
        }
        
        hideBothPins()
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == locationTextField {
            locationCoord = CLLocationCoordinate2D()
            if destChosen {
                replaceAnnotation(named: "Destination")
            }
            performSegue(withIdentifier: "searchSegueLocation", sender: self)
        } else {
            
            replaceAnnotation(named: "Location")
            
            destinationCoord = CLLocationCoordinate2D()
            if locationCoord.latitude == 0 && locationCoord.longitude == 0 {
                locationCoord = mapView.centerCoordinate
            }
            performSegue(withIdentifier: "searchSegueDestination", sender: self)
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Mark: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title!! != "Location" && annotation.title! != "Destination" {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            
            if annotation.title!! == "Location" {
                annotationView.image = #imageLiteral(resourceName: "map-pin-red")
            } else {
                annotationView.image = #imageLiteral(resourceName: "map-pin-green")
            }
        }
        
        return annotationView
    }
    
    @IBAction func onConfirm(_ sender: Any) {
        API.requestRide(location:  locationCoord,
                            destination: destinationCoord,
                            date: Date(),
                            success: { (object: PFObject) in
                                print("success")
                                
                                let alertController = UIAlertController(title: "Ride requested!", message: "Look for a text message from your drivers.", preferredStyle: .alert)
                                
                                // create an OK action
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    // handle response here.
                                }
                                // add the OK action to the alert controller
                                alertController.addAction(OKAction)
                                
                                self.present(alertController, animated: true) {
                                    // optional code for what happens after the alert controller has finished presenting
                                }
                            }, failure: { (error: Error) in
                                print("fail")
                            })
    }
    
    @IBAction func goToCurrentLocation(_ sender: Any) {
        mapView.centerCoordinate = userCoord
        movedMap()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegueLocation" || segue.identifier == "searchSegueDestination" {
            let locationsVC = segue.destination as! LocationsViewController
            locationsVC.delegate = self
            
            if segue.identifier == "searchSegueLocation" {
                locationsVC.locDest = "loc"
            } else {
                locationsVC.locDest = "dest"
            }
        }
    }
    
    func removeAnnotations(named: String) {
        let filteredAnnotations = mapView.annotations.filter { annotation in
            if annotation is MKUserLocation { return false }
            
            if let title = annotation.title, title == named {
                return true
            }
            return false
        }
        mapView.removeAnnotations(filteredAnnotations)
    }
    
    func setTextField(textField: UITextField, coord: CLLocationCoordinate2D) {
        setTextField(textField: textField, coord: coord, name: "(\(coord.latitude), \(coord.longitude))")
    }
    
    func setTextField(textField: UITextField, coord: CLLocationCoordinate2D, name: String) {
        if semiEqualCoords(c1: coord, c2: userCoord, diff: 0.000015) {
            atCurrentLocation(textField: textField)
        } else {
            standardLocation(textField: textField, name: name)
        }
    }
    
    func equalCoords(c1: CLLocationCoordinate2D , c2: CLLocationCoordinate2D) -> Bool {
        return c1.longitude == c2.longitude && c1.latitude == c2.latitude
    }
    
    func semiEqualCoords(c1: CLLocationCoordinate2D , c2: CLLocationCoordinate2D, diff: Double) -> Bool {
        return abs(c1.longitude - c2.longitude) < diff && abs(c1.latitude - c2.latitude) < diff
    }
    
    func atCurrentLocation(textField: UITextField) {
        textField.text = "Current Location"
        textField.textColor = UIColor(colorLiteralRed: 14/255.0, green: 122/255.0, blue: 254/255.0, alpha: 1) //Apple system blue
    }
    
    func standardLocation(textField: UITextField, name: String) {
        textField.text = name
        textField.textColor = UIColor(colorLiteralRed: 191/255.0, green: 87/255.0, blue: 0/255.0, alpha: 1) //Burnt Orange
    }
    
    func hideBothPins() {
        hidePins(location: true, destination: true)
    }
    
    func hidePins(location: Bool, destination: Bool) {
        locationPin.isHidden = location
        destinationPin.isHidden = destination
    }
    
    func setFullRegion() {
        
        for overlay in mapView.overlays {
            mapView.remove(overlay)
        }
        
        let midpoint = CLLocationCoordinate2DMake((locationCoord.latitude + destinationCoord.latitude) / 2, (locationCoord.longitude + destinationCoord.longitude) / 2)
        let latDistance = abs(locationCoord.latitude - destinationCoord.latitude) * 250000
        let longDistance = abs(locationCoord.longitude - destinationCoord.longitude) * 250000
        
        let region = MKCoordinateRegionMakeWithDistance(midpoint, latDistance, longDistance)
        mapView.setRegion(region, animated: false)
    
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: locationCoord))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoord))
        directionsRequest.transportType = .walking
        let directions = MKDirections(request: directionsRequest)
        let sureMapView = mapView
        directions.calculate { (response: MKDirectionsResponse?, error: Error?) in
            if !(error != nil) {
                for route in response!.routes {
                    sureMapView?.add(route.polyline, level: .aboveRoads)
                }
            }
        }
    }
    
    func replaceAnnotation(named: String) {
        var coord = CLLocationCoordinate2D()
        
        if named == "Location" {
            coord = locationCoord
        } else {
            coord = destinationCoord
        }
        
        removeAnnotations(named: named)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = named
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    @IBAction func switchMapStyle(_ sender: UISegmentedControl) {
        print(sender)
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
