//
//  EditShortBioVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 8/16/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class EditShortBioVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var editShortBioBox: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editShortBioBox.delegate = self
        editShortBioBox.isScrollEnabled = false
        editShortBioBox.translatesAutoresizingMaskIntoConstraints = false
        editShortBioBox.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Set the bio to display either your current bio, or the placeholder text
        print("SHORT BIO")
        print(UserManager.shared.currentUser?.shortBio)
        if isValidBio(bio: UserManager.shared.currentUser?.shortBio ?? "") {
            editShortBioBox.text = UserManager.shared.currentUser?.shortBio
            updateCharCount()
        } else {
            editShortBioBox.text = "Don't leave this lonely box blank!"
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //If there is placeholder text, then make the bio empty. Otherwise don't.
        if editShortBioBox.text == "Don't leave this lonely box blank!" {
            editShortBioBox.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = editShortBioBox.sizeThatFits(size)
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
        characterCountLabel.text = "Character count: \(editShortBioBox.text.count)"
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        //If the user didn't type a valid bio, then put up the placeholder text.
        if isValidBio(bio: editShortBioBox.text ?? "") == false {
            editShortBioBox.text = "Don't leave this lonely box blank!"
        }
        editShortBioBox.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            editShortBioBox.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func isValidBio(bio: String) -> Bool {
        var valid = true
        if bio == nil {
            valid = false
        } else if bio == "" {
            valid = false
        } else if bio == "Don't leave this lonely box blank!" {
            valid = false
        }
        print("Bio is valid? \(valid)")
        return valid
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare for segue called: Saving data...")
        if isValidBio(bio: editShortBioBox.text) {
            UserManager.shared.currentUser?.shortBio = editShortBioBox.text
            UserRequests().updateUserInFirestore(userObject: UserManager.shared.currentUser!)
        } else {
            UserManager.shared.currentUser?.shortBio = ""
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        editShortBioBox.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
}
