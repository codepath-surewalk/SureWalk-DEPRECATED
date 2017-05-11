//
//  MainViewController.swift
//  SureWalk
//
//  Created by Vaidehi Duraphe on 3/23/17.
//  Copyright © 2017 Vaidehi Duraphe. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class MainViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient_SUREWalk.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        loginButton.layer.cornerRadius = 5
        signupButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(_ sender: UIButton) {
        if textFieldEmpty(textField: usernameField) || textFieldEmpty(textField: passwordField) {
            var title = ""
            if textFieldEmpty(textField: usernameField) {
                title = "Missing username"
            } else {
                title = "Missing password"
            }
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "I'll type it in", style: .default) { (action) in
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
            }
            
            return
        }
        
        let loadingHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingHUD.mode = .indeterminate
        loadingHUD.label.text = "Logging in..."
        
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user:PFUser?, error: Error?) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else if (error != nil) {
                
                let alertController = UIAlertController(title: "Invalid username/password", message: nil, preferredStyle: .alert)
                
                // create an OK action
                let OKAction = UIAlertAction(title: "Try again", style: .default) { (action) in
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                    self.passwordField.text = ""
                }
            }
        }

    }

    func textFieldEmpty(textField: UITextField) -> Bool {
        return textField.text == nil || textField.text?.characters.count == 0
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
