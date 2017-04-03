//
//  RequestViewController.swift
//  SureWalk
//
//  Created by Vaidehi Duraphe on 3/20/17.
//  Copyright © 2017 Vaidehi Duraphe. All rights reserved.
//

import UIKit


class RequestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker2: UIPickerView!
    var pickerData: [String] = [String]()

    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.picker2.delegate = self
        self.picker2.dataSource = self
        
        pickerData = ["Kinsolving", "Jester", "Duren", "Carothers", "Moore Hill", "PCL", "Castillian", "Callaway", "FAC", "Blanton", "Whitis", "Littlefield", "Andrews", "ETC", "ECJ", "GDC", "McCombs", "Welch", "CPE", "SAC"]

        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient_SUREWalk.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient_SUREWalk.jpg")!)
       
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // The number of columns of data
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
        
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let titleData = pickerData[row]
    let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
    return myTitle
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
