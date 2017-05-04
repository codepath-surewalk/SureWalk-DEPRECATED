//
//  SignupViewController.swift
//  SureWalk
//
//  Created by Vaidehi Duraphe on 3/27/17.
//  Copyright © 2017 Vaidehi Duraphe. All rights reserved.
//

import UIKit
import Parse


class SignupViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient_SUREWalk.jpg")
        self.view.insertSubview(backgroundImage, at: 0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignup(_ sender: UIButton) {
        let newUser = PFUser()
        newUser.username = username.text
        newUser.password = password.text
        newUser["phone"] = Int(phoneNumber.text!)!
        newUser["firstName"] = firstName.text!
        newUser["lastName"] = lastName.text!
        newUser["driver"] = true

        newUser.signUpInBackground { (success: Bool, error: Error?) -> Void in
            if success {
                print("yay, created a user!")
                self.performSegue(withIdentifier: "signupSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
                /*
                 if error. == 202 {
                 print("Username is taken")
                 }
                 */
            }
        }
        self.dismiss(animated: true) { 
            
        }
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
