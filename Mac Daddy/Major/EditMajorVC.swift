//
//  EditMajorVC.swift
//  Mac Daddy
//
//  Created by Shane Barys on 2/15/20.
//  Copyright © 2020 Synestha. All rights reserved.

//

import Foundation
import UIKit
import Firebase

class EditMajorVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var majorPicker: UIPickerView!
    
    @IBOutlet weak var majorLabel: UILabel!
    
    var majors = UserManager.shared.currentUser?.majors
    //MARK: Remember that majors is an array
    //MARK: Use the function UserRequests().saveProfileChanges() to automaticall push any changes in UserManager to the database.
    
    var pickerData = ["African and African Diaspora Studies",
                         "Art History",
                         "Biochemistry",
                         "Biology",
                         "Chemistry",
                         "Classical Studies",
                         "Communication",
                         "Computer Science",
                         "Economics",
                         "English",
                         "Environmental Geoscience",
                         "Environmental Studies",
                         "Film Studies",
                         "French",
                         "Geological Sciences",
                         "German Studies",
                         "Hispanic Studies",
                         "History",
                         "Independent",
                         "International Studies",
                         "Islamic Civilization and Societies",
                         "Italian",
                         "Linguistics",
                         "Mathematics",
                         "Music",
                         "Neuroscience",
                         "Philosophy",
                         "Physics",
                         "Political Science",
                         "Psychology",
                         "Russian",
                         "Slavic Studies",
                         "Sociology",
                         "Studio Art",
                         "Theater",
                         "Theology",
                         "American Heritage",
                         "Applied Psychology and Human Development",
                         "Elementary Education",
                         "General Science",
                         "Mathematics/Computer Science",
                         "Perspectives on Spanish America",
                         "Secondary Education",
                         "Accounting",
                         "Business Analytics",
                         "Computer Science",
                         "Corporate Reporting and Analysis",
                         "Entrepreneurship",
                         "Finance",
                         "General Management",
                         "Information Systems",
                         "Information Systems and Accounting",
                         "Management and Leadership",
                         "Managing for Social Impact and the Public Good",
                         "Marketing",
                         "Operations Management",
                         "Nursing",
                         "Corporate Systems",
                         "Criminal and Social Justice",
                         "Natural Sciences",
                         "Social Sciences"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addMajorButtonPressed(_ sender: UIButton) {
        print("major add button pressed")
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        print("save button pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
  
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
     }
    
}
