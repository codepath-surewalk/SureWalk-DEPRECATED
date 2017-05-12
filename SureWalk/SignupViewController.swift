//
//  SignupViewController.swift
//  SureWalk
//
//  Created by SureWalk Team on 3/27/17.
//  Copyright © 2017 SureWalk Team. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import UITextField_Shake
import HTYTextField

class SignupViewController: UIViewController {

    @IBOutlet weak var firstName: HTYTextField!
    @IBOutlet weak var lastName: HTYTextField!
    @IBOutlet weak var username: HTYTextField!
    @IBOutlet weak var phoneNumber: HTYTextField!
    @IBOutlet weak var password: HTYTextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alertView: AlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient_SUREWalk.jpg")
        self.view.insertSubview(backgroundImage, at: 0)

        signUpButton.layer.cornerRadius = 5.0
        
        firstName.rightPlaceholder = "First Name"
        lastName.rightPlaceholder = "Last Name"
        username.rightPlaceholder = "UT EID"
        phoneNumber.rightPlaceholder = "xxx-xxx-xxxx"
        password.rightPlaceholder = "Password"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignup(_ sender: UIButton) {
        
        if !AlertView.isInternetAvailable() {
            alertView.isHidden = false
            return
        }
        
        if !checkCompletion() {
            return
        }
        
        if !checkCorrectness() {
            return
        }
        
        let newUser = PFUser()
        newUser.username = username.text
        newUser.password = password.text
        newUser["phone"] = sanitizedPhone(phoneNumber: phoneNumber.text!)
        newUser["firstName"] = firstName.text!
        newUser["lastName"] = lastName.text!
        newUser["driver"] = false
        
        let loadingHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingHUD.label.text = "One sec..."
        
        loadingHUD.detailsLabel.text = "Our monkeys are \ntyping away furiously"
        
        newUser.signUpInBackground { (success: Bool, error: Error?) -> Void in
            if success {
                sleep(2)
                loadingHUD.hide(animated: true)
                
                loadingHUD.customView = UIImageView(image: #imageLiteral(resourceName: "Checkmark"))
                loadingHUD.mode = .customView
                loadingHUD.label.text = "Done"
                loadingHUD.detailsLabel.text = "Shakespeare completed!"
                loadingHUD.minSize = CGSize(width: 100, height: 100)
                
                loadingHUD.show(animated: true)
                
                DispatchQueue.global().async(execute: {
                    DispatchQueue.main.sync{
                        sleep(2)
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.performSegue(withIdentifier: "signupSegue", sender: nil)
                    }
                })
                
            } else {
                //print(error?.localizedDescription)
                /*
                 if error. == 202 {
                 print("Username is taken")
                 }
                 */
                //   }
            }
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkCompletion() -> Bool {
        var toShake: UITextField?
        
        if textFieldEmpty(textField: firstName) {
            toShake = firstName
        } else if textFieldEmpty(textField: lastName) {
            toShake = lastName
        } else if textFieldEmpty(textField: username) {
            toShake = username
        } else if textFieldEmpty(textField: phoneNumber) {
            toShake = phoneNumber
        } else if textFieldEmpty(textField: password) {
            toShake = password
        }
        
        if toShake == nil {
            return true
        }
        
        shakeTextField(textField: toShake!)
        
        return false
    }
    
    func checkCorrectness() -> Bool {
        
        //Check that UT EID contains digits
        var hasNumber = false
        var hasLetter = false
        for chr in username.text!.characters {
            if (chr >= "0" && chr <= "9") {
                hasNumber = true
            }
            if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z")) {
                hasLetter = true
            }
        }
        if !hasNumber || !hasLetter {
            shakeTextField(textField: username)
            return false
        }
        
        //Check that phone number is has 10 digits
        let sanitizedPhoneNumber = sanitizedPhone(phoneNumber: phoneNumber.text!)
        if sanitizedPhoneNumber / 1000000000 < 1 {
            
            shakeTextField(textField: phoneNumber)
            
            return false
        }
        
        return true
    }
    
    func textFieldEmpty(textField: UITextField) -> Bool {
        return textField.text == nil || textField.text?.characters.count == 0
    }
    
    func shakeTextField(textField: UITextField!) {
        textField.shake(10, // 10 times
            withDelta: 5.0,  // 5 points wide
            speed: 0.03,     // 30ms per shake
            shakeDirection: ShakeDirection.horizontal)
    }
    
    func sanitizedPhone(phoneNumber: String) -> Int {
        return Int(String(phoneNumber.characters.filter { "0123456789".characters.contains($0) }))!
    }
    
    @IBAction func didTap(_ sender: Any) {
        view.endEditing(true)
    }
}
