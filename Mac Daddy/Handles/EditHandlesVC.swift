//
//  EditHandlesVC.swift
//  Mac Daddy
//
//  Created by Kevin Li on 2/8/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import UIKit

class EditHandlesVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var editvHandleBox: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editvHandleBox.delegate = self
        editvHandleBox.isScrollEnabled = false
        editvHandleBox.translatesAutoresizingMaskIntoConstraints = false
        editvHandleBox.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Set the vHandle to display either your vHandle, or the placeholder text
        print("SHORT BIO")
        print(UserManager.shared.currentUser?.vHandle)
        if isValidvHandle(vHandle: UserManager.shared.currentUser?.vHandle ?? "") {
            editvHandleBox.text = UserManager.shared.currentUser?.vHandle
            updateCharCount()
        } else {
            editvHandleBox.text = "Don't leave this lonely box blank!"
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //If there is placeholder text, then make the vHandle empty. Otherwise don't.
        if editvHandleBox.text == "Don't leave this lonely box blank!" {
            editvHandleBox.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = editvHandleBox.sizeThatFits(size)
        textView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height >= 60 {
                    constraint.constant = estimatedSize.height
                } else {
                    constraint.constant = 60
                }
            }
        }
        updateCharCount()
    }
    
    func updateCharCount() {
        characterCountLabel.text = "Character count: \(editvHandleBox.text.count)"
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        //If the user didn't type a valid vHandle, then put up the placeholder text.
        if isValidvHandle(vHandle: editvHandleBox.text ?? "") == false {
            editvHandleBox.text = "Don't leave this lonely box blank!"
        }
        editvHandleBox.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            editvHandleBox.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func isValidvHandle(vHandle: String) -> Bool {
        var valid = true
        if vHandle == nil {
            valid = false
        } else if vHandle == "" {
            valid = false
        } else if vHandle == "Don't leave this lonely box blank!" {
            valid = false
        }
        print("Where the Venmo @? \(valid)")
        return valid
    }
    
    
    //Make new scenes
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for segue called: Saving data...")
        if isValidvHandle(vHandle: editvHandleBox.text) {
            UserManager.shared.currentUser?.vHandle = editvHandleBox.text
            UserRequests().updateUserInFirestore(userObject: UserManager.shared.currentUser!)
        } else {
            UserManager.shared.currentUser?.vHandle = ""
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        editvHandleBox.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
}
