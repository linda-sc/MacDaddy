//
//  AnswerzPromptVC.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/16/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit
import Foundation

class PostGigVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var charCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        answerTextView.delegate = self
        answerTextView.isScrollEnabled = false
        submitButton.layer.cornerRadius = 10
    }

    // MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
    
        if isValidPost(post: answerTextView.text){
            print("Post:")
            print(answerTextView.text ?? "...")
            self.submitPost {
                self.submitButton.titleLabel?.text = "Done"
                self.dismiss(animated: true, completion: nil)
            }
            
        } else{
            print("Not valid post.")
        }
        
    }
    
    func submitPost(completed: @escaping ()-> ()) {
        self.submitButton.titleLabel?.text = "Posting..."
        
        let uid = UserManager.shared.currentUser?.uid
        let email = UserManager.shared.currentUser?.email
        let venmo = UserManager.shared.currentUser?.venmo
        let text = self.answerTextView.text
        
        let gigObject = GigObject()
        
        gigObject.uid = uid
        gigObject.email = email
        gigObject.venmo = venmo
        gigObject.text = text
        
        let gigId = self.createGigID()
    
        UserRequests().insertGigInFirestore(gigObject: gigObject, gigId: gigId)
        
        completed()
    }
    
    func createGigID() -> String {
        let newGigID = Constants.refs.databaseGigs.childByAutoId()
        return newGigID.key!
    }
    
    
    // MARK: - TextView Protocol
    func textViewDidBeginEditing(_ textView: UITextView) {
        //If there is placeholder text, then make the bio empty. Otherwise don't.
        if answerTextView.text == "Type your post here" {
            answerTextView.text = ""
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = answerTextView.sizeThatFits(size)
        textView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height * 1.5 >= 60 {
                    constraint.constant = estimatedSize.height * 1.5
                } else {
                    constraint.constant = 60
                }
            }
        }
        updateCharCount()
    }
    
    func updateCharCount() {
        charCountLabel.text = " \(200 - answerTextView.text.count) characters left"
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        //If the user didn't type a valid bio, then put up the placeholder text.
        if isValidPost(post: answerTextView.text ?? "") == false {
            answerTextView.text = "Type your answer here"
        }
        answerTextView.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            answerTextView.resignFirstResponder()
            return false
        }
        return textView.text.count + (text.count - range.length) <= 200
    }
    
    
    func isValidPost(post: String) -> Bool {
        var valid = true
        let rawPost = post.trimmingCharacters(in: .whitespacesAndNewlines)
        if rawPost == "" {
            valid = false
        } else if post == "" {
            valid = false
        } else if post == "Type your answer here" {
            valid = false
        }
        
        for badWord in Constants.badWords {
            if (post.containsIgnoringCase(find: badWord)) {
                valid = false
            }
        }
        
        print("Post is valid? \(valid)")
        return valid
    }
    
    // MARK: - NETWORK CALLS
    // MARK: - Given: User, game, turn, and phase
    // MARK: - Action: Submit response to response phase
    // MARK: - Confirmation: Proceed once response is submitted
    
}


