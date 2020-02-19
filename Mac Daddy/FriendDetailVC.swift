//
//  FriendProfileVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 11/13/18.
//  Copyright © 2018 Synestha. All rights reserved.
//

import UIKit

class FriendDetailVC: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var friend = Friend()
    var userObject = UserObject()
    var friendship = FriendshipObject()
    var reportText = ""
    
    @IBOutlet weak var detailCollection: UICollectionView!
    @IBOutlet weak var detailCollectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var friendPicture: UIImageView!
    @IBOutlet weak var activeBubble: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var tabBarBackground: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //ChatHandler.messages = [JSQMessage]()
        detailCollection.delegate = self
        detailCollection.dataSource = self
        
        friendButton.setTitle(friend.name, for: .normal)
        if (friend.active == "1") {
            activeBubble.isHidden = false
        } else {
            activeBubble.isHidden = true
        }
        
        //If the friend is anonymous, use one of the default pictures.
        //We haven't implemented pictures yet so let's just leave it like this.
        //if friend.anon == "1" {
        if true {
            if friend.macStatus == "Daddy" {
                friendPicture.image = UIImage(named: "MacDaddyLogo_Purple")
            } else {
                friendPicture.image = UIImage(named: "MacDaddyLogo")
            }
        }
        
        DataHandler.updateActive(active: "1")
        
        
        //Background
//        if DataHandler.macStatus == "Daddy" {
//            background.image = UIImage(named: "MacDaddy Background_Purple")
//            tabBarBackground.image = UIImage(named: "TabBar_Purple")?.alpha(0.5)
//
//        }else if DataHandler.macStatus == "Baby" {
//            background.image = UIImage(named: "MacDaddy Background")
//            tabBarBackground.image = UIImage(named: "TabBar")?.alpha(0.5)
//        }
        
        background.image = UIImage(named: "MacDaddy Background_DarkMode")
        tabBarBackground.image = UIImage(named: "MacDaddy Background_DarkMode")?.alpha(0.5)
        
        //Register Nibs
        detailCollection.register(UINib.init(nibName: "MapCell", bundle: nil), forCellWithReuseIdentifier: "MapCell")
        detailCollection.register(UINib.init(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "UserCell")
        
        //Set layout
        if let flow = detailCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        let flowLayout = BouncyLayout(style: .prominent)
        self.detailCollection.setCollectionViewLayout(flowLayout, animated: true)
        
        
        /*** Register cell nibs ***/
        detailCollection.register(UINib.init(nibName: "HeaderCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCell")
        detailCollection.register(UINib.init(nibName: "BasicInfoCell", bundle: nil), forCellWithReuseIdentifier: "BasicInfoCell")
        detailCollection.register(UINib.init(nibName: "GradeStatusCell", bundle: nil), forCellWithReuseIdentifier: "GradeStatusCell")
        detailCollection.register(UINib.init(nibName: "BioCell", bundle: nil), forCellWithReuseIdentifier: "BioCell")
        detailCollection.register(UINib.init(nibName: "MapCell", bundle: nil), forCellWithReuseIdentifier: "MapCell")
        detailCollection.register(UINib.init(nibName: "InterestCell", bundle: nil), forCellWithReuseIdentifier: "InterestCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Using a closure function with error handling.
        //The "result" is the success result returned from the function
        //If the result is in, then set the friendObject to the downloaded object.
        //Otherwise, throw an error.
        UserRequests().fetchUserObject(userID: friend.uid, success: { (result) in
            if let userObject = result as? UserObject {
                self.userObject = userObject
                self.detailCollection.reloadData()
            }
        }) { (error) in
            print("Couldn't fetch user object.")
        }
    }

    //Use a custom segue here.
    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindFromFriendDetail", sender: nil)
    }
    
    
    //MARK: BLOCKING AND REPORTING
    @IBAction func displayActionSheet(_ sender: Any) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let unmatchAction = UIAlertAction(title: "Unmatch", style: .default) {
            UIAlertAction in
            self.presentUnmatchAlert()
        }
        
        let blockAction = UIAlertAction(title: "Block & Report", style: .default) {
            UIAlertAction in
            self.presentBlockAlert()
        }
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        optionMenu.addAction(unmatchAction)
        optionMenu.addAction(blockAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func presentUnmatchAlert() {
        
        //COPIED AND PASTED FROM HOMEVC.
        //Take out the word "Anonymous"
        var nickname = ""
        
        if friend.anon == "1" {
            nickname = friend.name.substring(from: 10)
        } else {
            nickname = friend.name
        }
        
        //Set up the alert controller
        let message = "You are about to end your conversation with \(friend.name)."
        let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
        
        // Create the actions
        //Delete a friend: could be your current match, an incoming match, or a friend
        let okAction = UIAlertAction(title: "Goodbye, \(nickname).", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            print("Goodbye pressed")
            
    
            FriendshipRequests().archiveFriendshipObject(friendship: self.friendship, completion: {
                success in
                    let isAnon = (self.friend.anon == "1")
                           
                   //First just delete them normally
                   DataHandler.deleteFriend(friend: self.friend, anon: isAnon)
                   
                   //If that was your current match, take it out, and remove your current match ID.
                   if self.friend.uid == DataHandler.currentMatchID {
                       DataHandler.updateCurrentMatchID(currentMatchID: "")
                       print("Deleting current match")
                   } else if isAnon {
                       //Else, if you were THEIR current match, remove their current match ID.
                       //Any anonymous friend that is not your current match must be an incoming match
                        DataHandler.updateUserData(uid: self.friend.uid, values: ["7: MatchID": ""])
                       print("Deleting incoming match")
                   }
                   
                   self.performSegue(withIdentifier: "unwindFromBlock", sender: self)
            })
        }
        
        let cancelAction = UIAlertAction(title: "No, I like \(nickname).", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func presentBlockAlert() {
        //COPIED AND PASTED FROM HOMEVC.
        //Take out the word "Anonymous"
        var nickname = ""
        
        if friend.anon == "1" {
            nickname = friend.name.substring(from: 10)
        } else {
            nickname = friend.name
        }
        
        //Set up the alert controller
        let message = "You are about to block \(friend.name). Help us keep Mac Daddy safe by telling us why you are blocking this user. Don't worry, you will remain completely anonymous."
        
        let alert = UIAlertController(title: "Is there something wrong?", message: message, preferredStyle: .alert)
        
        let problem1 = UIAlertAction(title: "\(nickname) is being inappropriate.", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.reportText = "Inappropriate"
            self.presentblockConfirmationAlert()
        }
        let problem2 = UIAlertAction(title: "Abusive or threatening behavior.", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.reportText = "Abusive"
            self.presentblockConfirmationAlert()
        }
        let problem3 = UIAlertAction(title: "Fraud, spam, or scam.", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.reportText = "Fraud"
            self.presentblockConfirmationAlert()
        }
        let problem4 = UIAlertAction(title: "I just don't like \(nickname).", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.reportText = "None"
            self.presentblockConfirmationAlert()
        }
        
        let cancelAction = UIAlertAction(title: "Never mind.", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alert.addAction(problem1)
        alert.addAction(problem2)
        alert.addAction(problem3)
        alert.addAction(problem4)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentblockConfirmationAlert() {
        DataHandler.blockFriend(friend: friend, report: reportText)
        
        let message = "This user has been blocked."
        let alert = UIAlertController(title: "Thanks for your feedback.", message: message, preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "unwindFromBlock", sender: self)
        }
        
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: CollectionView

extension FriendDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "BasicInfoCell", for: indexPath) as! BasicInfoCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            cell.loadForUser(friend: self.friend, userObject: self.userObject)
            return cell
        case 1:
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "GradeStatusCell", for: indexPath) as! GradeStatusCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            cell.loadForUser(friend: self.friend)
            self.setStructure(for: cell)
            return cell
        case 2:
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "BioCell", for: indexPath) as! BioCell
            //cell.parentViewController = self
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            cell.loadForUser(user: self.userObject)
            return cell
        case 3:
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            cell.updateMap()
            self.setStructure(for: cell)
            return cell
        case 4:
            //Anonymous public info
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            self.formatHeader(for: cell, title: "About")
            return cell
        case 5:
            //Major Cell
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            cell.moreIcon.isHidden = true
            self.setStructure(for: cell)
            let major = self.userObject.majors?.first ?? "Eating and sleeping"
            self.formatInterest(for: cell, iconName: "majorIcon", interestName: "Major", interestField: major)
            return cell
        case 6:
            //Terms Cell
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            cell.moreIcon.isHidden = true
            let terms = self.userObject.terms ?? "I don't know"
            self.formatInterest(for: cell, iconName: "venmoIcon", interestName: "My terms", interestField: terms)
            self.setStructure(for: cell)
            return cell
        case 7:
            //Visible to friends only
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            self.formatHeader(for: cell, title: "Visible to friends only")
            return cell
        default:
            //Venmo Cell
            let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            cell.moreIcon.isHidden = true
            
            //Friends structs currently better at keeping track of anonymity.
            var venmo = ""
            if self.friend.anon == "1" {
                venmo = "???"
            } else {
                venmo = self.userObject.venmo ?? "???"
            }
             self.formatInterest(for: cell, iconName: "venmoIcon", interestName: "Venmo handle", interestField: venmo)
            
            self.setStructure(for: cell)
            return cell
        }
    }
    
    private func setStructure(for cell: UICollectionViewCell) {
        cell.layer.borderWidth = 20
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 15
    }
    
    private func formatHeader(for cell: HeaderCell, title: String) {
        cell.headerTitle.text = title
    }
    
    private func formatInterest(for cell: InterestCell, iconName: String, interestName: String, interestField: String) {
        cell.interestName.text = interestName
        cell.interestField.text = interestField
        //cell.interestIcon.image = UIImage(named: iconName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            //Basic Info Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 200
            return CGSize(width: width, height: height)
        case 1:
            //Grade Status Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 60
            return CGSize(width: width, height: height)
        case 2:
            //Bio Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 100
            return CGSize(width: width, height: height)
        case 3:
            //Map Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 300
            return CGSize(width: width, height: height)
        case 4:
            //Anonymous Public Info
            let width = view.bounds.width - 16
            let height: CGFloat = 60
            return CGSize(width: width, height: height)
        case 5:
            //Major Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 40
            return CGSize(width: width, height: height)
        case 6:
            //Terms Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 40
            return CGSize(width: width, height: height)
        case 7:
            //Visible to friends only
            let width = view.bounds.width - 16
            let height: CGFloat = 60
            return CGSize(width: width, height: height)
        default:
            //Venmo Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 40
            return CGSize(width: width, height: height)
        }
    }
    
    /****************************************************************/
    // Estimates cell height
    /****************************************************************/
    func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 1000
        //Set the width to the width of the text in the cell.
        let width: CGFloat = 250
        
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
