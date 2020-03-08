//
//  EditMajorVC.swift
//  Mac Daddy
//
//  Created by Kevin Li on 2/15/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditMajorVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var majorPicker: UIPickerView!
    @IBOutlet weak var majorLabel1: UILabel!
    @IBOutlet weak var majorLabel2: UILabel!
    @IBOutlet weak var majorLabel3: UILabel!
    @IBOutlet weak var majorField: UITextField!
    
    
    var majorz = ["None", "Accounting", "African and African Diaspora Studies", "American Heritage", "Applied Psychology and Human Development", "Art History","Biochemistry", "Biology", "Business Analytics", "Chemistry", "Classical Studies", "Communication", "Computer Science", "Corporate Reporting and Analysis", "Corporate Systems", "Criminal and Social Justice", "Economics", "Elementary Education", "English", "Entrepreneurship", "Environmental Geoscience", "Environmental Studies", "Film Studies", "Finance", "French", "General Management", "General Science", "Geological Sciences", "German Studies", "Hispanic Studies", "History", "Independent", "Information Systems and Accounting", "Information Systems", "International Studies", "Islamic Civilization and Societies", "Italian", "Linguistics", "Management and Leadership", "Managing for Social Impact and the Public Good", "Marketing", "Mathematics", "Mathematics/Computer Science", "Music", "Natural Sciences", "Neuroscience", "Nursing", "Operations Management", "Perspectives on Spanish America", "Philosophy", "Physics", "Political Science", "Psychology", "Russian", "Secondary Education", "Slavic Studies", "Social Sciences", "Sociology", "Studio Art", "Theater", "Theology"]

    var yourMajor = UserManager.shared.currentUser?.majors
        var selectedMajorsString = ""
        var selectedMajors = [String] ()
        var isSpinning  = false
    var lineCount = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            majorPicker.isHidden = false
            majorPicker.delegate = self
            majorPicker.dataSource = self
            majorField.inputView = majorPicker
            majorField.textAlignment = .center
            majorField.isHidden = true
            selectedMajorsString = UserManager.shared.currentUser?.majors?.joined(separator: ", ") ?? "Nothing"
            selectedMajors = UserManager.shared.currentUser?.majors ?? ["Nothing"]
            print("Current majors: ", UserManager.shared.currentUser?.majors ?? "No major")
            showLabelsAndButtons()
            print ("majorViewDidLoaded")
        }
        

    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        if majorField.text == "None" || majorField.text == "majorField" {
            selectedMajorsString = ""
            selectedMajors = [String] ()
            NoneSelected()
            print("Count: ", selectedMajors.count)
        }
        else if selectedMajors.count > 3 {
            print("You are studying too much. Max 3 majors.")
            showLabelsAndButtons()
            print("Count: ", selectedMajors.count)
            return
        }
        else if (selectedMajorsString != "") {
            selectedMajorsString = selectedMajorsString + (majorField.text ?? "No major") + ", "
            selectedMajors = selectedMajorsString.components(separatedBy: ", ")
            selectedMajors.removeDuplicates()
            selectedMajorsString = selectedMajors.joined(separator: ", ")
            showLabelsAndButtons()
            print("Count: ", selectedMajors.count)
        }
        else if (selectedMajorsString == "") {
            selectedMajorsString = selectedMajorsString + (majorField.text ?? "No major") + ", "
            selectedMajors = selectedMajorsString.components(separatedBy: ", ")
            selectedMajors.removeDuplicates()
            selectedMajorsString = selectedMajors.joined(separator: ", ")
            showLabelsAndButtons()
            print("Count: ", selectedMajors.count)
            }
        print("String: ",selectedMajorsString)
        print("Array: ",selectedMajors)
        print("Count: ", selectedMajors.count)
    }
    
        func showLabelsAndButtons() {
            if (selectedMajors.count >= 2) {
                majorLabel1.text = selectedMajors[0]
                fadeMajors {
                }
                majorLabel1.isHidden = false
                majorLabel2.isHidden = true
                majorLabel3.isHidden = true
                majorLabel1.sizeToFit()
                majorLabel2.sizeToFit()
                majorLabel3.sizeToFit()
            }
            if (selectedMajors.count >= 3) {
                majorLabel2.text = selectedMajors[1]
                fadeMajors {
                }
                majorLabel2.isHidden = false
                majorLabel3.isHidden = true
                majorLabel1.sizeToFit()
                majorLabel2.sizeToFit()
                majorLabel3.sizeToFit()
            }
            if (selectedMajors.count >= 4) {
                majorLabel3.text = selectedMajors[2]
                fadeMajors {
                }
                majorLabel3.isHidden = false
                majorLabel1.sizeToFit()
                majorLabel2.sizeToFit()
                majorLabel3.sizeToFit()
            }
            else if (selectedMajors.count == 0) {
                    self.NoneSelected()
            }
        }
        
    //make fading out prettier at some point...3/2/20
        func NoneSelected() {
            fadeMajors {
                self.majorLabel1.fadeOut()
                self.majorLabel2.fadeOut()
                self.majorLabel3.fadeOut()
                self.majorLabel1.isHidden = true
                self.majorLabel2.isHidden = true
                self.majorLabel3.isHidden = true
            }
        }
        
    func fadeMajors(completed: @escaping ()-> ()){
        if (selectedMajors.count >= 2) {
              majorLabel1.fadeIn()
              majorLabel1.isHidden = false
              majorLabel2.isHidden = true
              majorLabel3.isHidden = true
          }
          if (selectedMajors.count >= 3) {
              majorLabel1.fadeIn()
              majorLabel2.fadeIn()
              majorLabel2.isHidden = false
              majorLabel3.isHidden = true
          }
          if (selectedMajors.count >= 4) {
              majorLabel1.fadeIn()
              majorLabel2.fadeIn()
              majorLabel3.fadeIn()
              majorLabel3.isHidden = false
          }
          else if (selectedMajors.count == 0) {
              majorLabel1.fadeOut()
              majorLabel2.fadeOut()
              majorLabel3.fadeOut()
        }
        completed()
    }
        
        
    //copypasta code for pickerView text resizing from https://stackoverflow.com/questions/36697286/how-can-i-make-my-uipickerview-multiline-in-swift/36701907
    //ty @ following 2 functions
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 60.0
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            self.isSpinning = true
            let label: UILabel

            if let view = view {
                label = view as! UILabel
            }
            else {
                label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 400))
            }

            label.text = majorz[row]
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.sizeToFit()
            label.textAlignment = .center
            return label
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                return majorz.count
        }
        
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return majorz[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                majorField.text = majorz[row]
                self.isSpinning = false
            
        }
        
        
        func textFieldDidBeginEditing(textField: UITextField) {
            majorPicker.reloadAllComponents()
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("Saving majors data...")
            UserManager.shared.currentUser?.majors = selectedMajors
            selectedMajors = UserManager.shared.currentUser?.majors ?? ["Must be something"]
            UserRequests().updateUserInFirestore(userObject: UserManager.shared.currentUser!)
            print ("Majors successfully saved")
        }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        selectedMajorsString = ""
        selectedMajors = [String] ()
        NoneSelected()
    }
    
    

}

//copypastacode for removeDuplicates func from https://medium.com/if-let-swift-programming/swift-array-removing-duplicate-elements-128a9d0ab8be
//ty

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}

//copypastacode for 2 fade in/out func from https://stackoverflow.com/questions/28288476/fade-in-and-fade-out-in-animation-swift
//ty
extension UIView {

    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
    }, completion: completion)  }

    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.3
    }, completion: completion)
   }
}
