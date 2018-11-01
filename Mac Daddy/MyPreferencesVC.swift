//
//  MyPreferences.swift
//  Mac Daddy
//
//  Created by Linda Chen on 6/6/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyPreferencesVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var background:UIImageView!
    @IBOutlet weak var selector:UISegmentedControl!
    
    var grade = DataHandler.grade
    var macStatus = DataHandler.macStatus
    var isDaddy = true
    
    @IBOutlet weak var picker:UIPickerView!
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //saveButton.layer.borderWidth = 2.0
        saveButton.layer.cornerRadius = 6
        //saveButton.layer.borderColor = UIColor.white.cgColor
        
        
        //Set background, put the selector on the previous setting:
        if DataHandler.macStatus == "Daddy" {
            background.image = UIImage(named: "MacDaddy Background_Purple")
            saveButton.backgroundColor = Constants.colors.neonCarrot
            self.selector.selectedSegmentIndex = 0
            
        }else {
            background.image = UIImage(named: "MacDaddy Background")
            saveButton.backgroundColor = Constants.colors.fadedBlue
            self.selector.selectedSegmentIndex = 1
        }
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Freshman", "Sophomore", "Junior", "Senior"]
        
        var previousRow = 0
        
        //Keep the picker on the previous option:
        if grade == "Freshman" {
            previousRow = 0
        } else if grade == "Sophomore" {
            previousRow = 1
        } else if grade == "Junior" {
            previousRow = 2
        } else {
            previousRow = 3
        }
        
        picker.selectRow(previousRow, inComponent: 0, animated: false)
        
        if macStatus == "Baby" {
            isDaddy = false
        }else{
            isDaddy = true
        }
    }
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        self.grade = pickerData[row]
    }
    
    //Change text color to white
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if row == 0{
            return NSAttributedString(string: "Freshman", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            
        } else if row == 1{
            return NSAttributedString(string: "Sophomore", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            
        }else if row == 2{
            return NSAttributedString(string: "Junior", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            
        }else{
            return NSAttributedString(string: "Senior", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])

        }
    }
    
    @IBAction func macSelectorChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isDaddy = !isDaddy
        //Check the boolean and set the button and labels
        if isDaddy
        {
            macStatus = "Daddy"
            background.image = UIImage(named: "MacDaddy Background_Purple")
            saveButton.backgroundColor = Constants.colors.neonCarrot
            label.text = macStatus
        }
        else
        {
            macStatus = "Baby"
            background.image = UIImage(named: "MacDaddy Background")
            saveButton.backgroundColor = Constants.colors.fadedBlue
            label.text = macStatus
        }
    }
    
    
    ////////////////////////////////////////////
    /////////  UPDATE FOR FIRESTORE  ///////////
    ////////////////////////////////////////////
    
    
    @IBAction func saveButtonTapped(_sender:UIButton){
        DataHandler.macStatus = macStatus
        print(DataHandler.macStatus)
        
        DataHandler.grade = grade
        let values = ["Grade": grade, "Mac Status": macStatus]
        let uid = Auth.auth().currentUser?.uid
        DataHandler.updateUserData(uid: uid!, values: values)
        print ("Grade and status successfully saved")
        self.performSegue(withIdentifier: "backToOptions", sender: self)
    }
}

