//
//  EditBasicInfoVC.swift
//  Mac Daddy
//
//  Created by Kevin Li on 6/28/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditBasicInfoVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
    var grade = DataHandler.grade
    var macStatus = DataHandler.macStatus
    var isDaddy = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewLoaded")
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveButtonAction {
            self.performSegue(withIdentifier: "goToUserProfile", sender: UIButton.self)
        }
    }
    
    //could have everything under saveButtonAction func put into saveButtonTapped
    func saveButtonAction(completed: @escaping()-> ()) {
        UserManager.shared.currentUser?.status = macStatus
        UserManager.shared.currentUser?.grade = grade
        // DataHandler.updateMacStatus(status: macStatus)
        //DataHandler.updateGrade(grade: grade)
        print ("Grade and status successfully saved")
        completed()
    }

}
