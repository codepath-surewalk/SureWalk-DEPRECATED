//
//  MapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    var imageToView: UIImage!
    var locationManager = CLLocationManager.init()

    
    enum MapType: NSInteger {
        case StandardMap = 0
        case SatelliteMap = 1
        case HybridMap = 2
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        let sfoRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                               MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfoRegion, animated: false)
        

        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient_SUREWalk.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_SUREWalk.jpg")!)
        
        
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

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagSegue" {
            let locationsVC = segue.destination as! LocationsViewController
            locationsVC.delegate = self
            print("hi i got ran")
        } else {
            print("no i didn't get ran")
        }
    }
    
    // Mark: – LocationsViewControllerDelegate
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        annotation.title = "\(latitude)"
        mapView.addAnnotation(annotation)
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    // Mark: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotationView as! MKAnnotation?, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = selectedImage
        
        return annotationView
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
