//
//  HomeViewController.swift
//  SureWalk
//
//  Created by SureWalk Team on 3/23/17.
//  Copyright © 2017 SureWalk Team. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient_SUREWalk.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
        
        let user = PFUser.current()!
        navigationBar.title = "\(user["lastName"] as! String), \(user["firstName"] as! String)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

}
