//
//  AlertView.swift
//  SureWalk
//
//  Created by Benny Singer on 5/12/17.
//  Copyright © 2017 Vaidehi Duraphe. All rights reserved.
//

import UIKit
import SystemConfiguration

class AlertView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isHidden = true
    }
    
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.isHidden = true
        
    }
    
    //source: http://stackoverflow.com/questions/39558868/check-internet-connection-ios-10
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

