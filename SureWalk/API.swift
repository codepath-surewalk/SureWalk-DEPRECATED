//
//  API.swift
//  SureWalk
//
//  Created by Benny Singer on 4/3/17.
//  Copyright © 2017 Vaidehi Duraphe. All rights reserved.
//

import UIKit
import Parse

class API: NSObject {
    
    class func requestRide(location: CLLocation, destination: CLLocation, time: Date, success: @escaping (PFObject) -> (), failure: @escaping (Error) -> ()) {
        
        let request = PFObject(className: "Request")
        
        // Add relevant fields to the object
        request["rider"] = PFUser.current() // Pointer column type that points to PFUser
        
        request["locationLongitude"] = location.coordinate.longitude
        request["locationLatitude"] = location.coordinate.latitude
        request["destinationLongitude"] = destination.coordinate.longitude
        request["destinationLatitude"] = destination.coordinate.latitude
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = timeFormatter.string(from: time)
        request["time"] = timeString
        
        request["driver1"] = NSNull()
        request["driver2"] = NSNull()
        
        // Save object (following function will save the object in Parse asynchronously)
        request.saveInBackground { (saved: Bool, error: Error?) in
            if (saved) {
                success(request)
            } else {
                failure(error!)
            }
        }
    }
    
    class func checkRequestStatus(request: PFObject, success: @escaping () -> (), failure: @escaping () -> ()) {
        let query = PFQuery(className: "Request")
        query.getObjectInBackground(withId: request["_id"] as! String) {
            (object, error) -> Void in
            if error != nil {
                failure()
            } else {
                if let object = object {
                    if object["driver1"] != nil || object["driver2"] != nil {
                        success()
                    }
                }
                failure()
            }

        }
    }
}
