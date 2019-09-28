//#hello???? this is Kevin???
//  HomeVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/12/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//UITableViewDataSource, UITableViewDelegate

//Keeping Firebase back end stuff on top.
class HomeVC: UIViewController {
    
    @IBOutlet weak var background:UIImageView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var matchBox:UIButton!

    
    var currentMatch = Friend()
    var selfListener:ListenerRegistration? = nil
    
    let friendRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("Friends")
    
    func testing() {
        //Testing this out
//        UserManager.shared.importCurrentUserFromDataHandler()
//        UserManager.shared.getLocation()
//        UserRequests().insertUserInFirestore(userObject: UserManager.shared.currentUser!)
        
        UserData.downloadAllUserObjects {
            //let lastActive = UserData.allUserObjects.first?.lastActive?.timeIntervalSinceNow
            //print("Active \(lastActive?.stringTimeAgo)")
        }
    }
    
    func removeObserver() {
        if selfListener != nil {
            selfListener!.remove()
            print("🙉 Removing old listener")
        }
    }
    
    func addObservers() {
        //Remove old listeners if there are any
        if selfListener != nil {
            selfListener!.remove()
            print("🙉 Removing old listener")
        }
 
        //Listen for new incoming matches
        //Also delete your current match if it gets deleted in the database
        selfListener = DataHandler.db.collection("users").document(DataHandler.uid!)
            .addSnapshotListener { querySnapshot, error in
                guard let _ = querySnapshot?.documentID else {
                    print("Error adding friend listeners: \(error!)")
                    return
                }
                print("👂🏻 HomeVC - addObserver: friend Listeners fired")
                print("querySnapshot documents: \(String(describing: querySnapshot?.documentID))")
                self.syncFriends()
                
        }
        

//        //Listen for changes in conversations
//        for friend in DataHandler.friendList {
//            let friendConvoRef = friendRef.child(friend.convoID)
//            friendConvoRef.observe(.value, with: { snapshot in
//                print("👂🏻 HomeVC - addObserver: friendConvoRef Listener fired")
//                self.syncConvos()
//            })
//        }
    }
    
    
    func syncConvos() {
        //Builds a parallel array of conversations in DataHandler
        //Qualities: seen, last message
        for friend in DataHandler.friendList {
            let friendUID = friend.uid
            let friendConvoRef = friendRef.child(friend.convoID)
            
            //DataHandler.convos.append(Convo.init(friendUID: friendUID, lastChat: lastChat, seen: seen))
        }
    }
    
    func syncFriends() {
        //Donwloads and converts Firebase dictionary of friends to DH, then to local list.
        print("💫 syncFriends beginning")
        DataHandler.checkData {
            DataHandler.downloadFriends {
                //Firestore function directly loads into the friendList, and skips the NSDictionary
                //DataHandler.friendList = DataHandler.friendDictionaryToList(friends: DataHandler.friends as! [String : [String : String]])
                print("💫 syncFriends: Array stored in DataHandler: \(DataHandler.friendList)")
                DataHandler.orderFriends()
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    print("💫 syncFriends: Reloading table data")
                }
            }
        }
    }
        
        //Ok this part's gonna be a little tedious but it's really important.
        //We're gonna have to add general time variables:
        //Currently Active, and last active.
        //Let's call those, online and lastActive, denoted by fake bools y and n.
        //Online and last Active apply to yourself AND everyone who is friends with you.
        //You have to update the data in your own location, as well as in everyone's friend lists.
        
        // We also want to do something similar with realtime updates within the conversation status.
        // Just like saving, typing is specific to your conversation. Let's do that first.
        // Let's go to ChatInterfaceVC to do this...
        
        
        //Later we're also probably gonna add current location here.
        
        // This is what's happening here:
        
        // 1. When something changes in Firebase, the observer is fired.
        // 2. Then syncFriends calls on DataHander.downloadFriends:
        // 3. DataHandler takes a snapshot of all your friends.
        // 4. DataHandler.friendDictionaryToList converts them to a list of Friend structs.
        // 5. The friend data is immediately stored in the DataHandler variable friendList.
        // 6. tableView.reloadData() displays them on your friends list.
        
        // 1. So if we're adding new variables, we first have to upload them to Firebase.
        // 2. Then we have to modify DataHandler.downloadFriends to take those variables.
        // 3. We also have to add the variables the Friend struct.
        // 4. And then we have to change the two methods that convert between dict and Friend.
        // 5. Storing that data in your list of friends is unchanged.
        // 6. We can further customize the friend cells to account for these changes.
    
}


//All UI stuff goes here
extension HomeVC {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        removeObserver()
        addObservers()
        
        matchBox.isEnabled = true
        self.matchBox.setTitle("Find a match!", for: .normal)
        
        
        //Lets make some code execute whenever the homescreen appears.
        //Then i can hand off the function to kevin
//        let userID = Auth.auth().currentUser?.uid
//        let ref = Database.database().reference()
//
//        ref.child("conversations").observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            let count = value?.count
//            print("We have \(count ?? 0) conversations.")
//        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserver()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        print("👁 HomeVC - viewDidLoad")
        DataHandler.updateActive(active: "1")
        print("🍱 Here are our friends \(DataHandler.friendList)")
        
        testing()
        if let uid = Auth.auth().currentUser?.uid {
            UserRequests().downloadCurrentUserObjectFromFirestore(userId: uid)
        }
        
        //Set up delegates and data sources
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set background for view and table:
        var backgroundImage:UIImage?
        var buttonImage:UIImage?
        
        //if DataHandler.macStatus == "Daddy" {
        if UserManager.shared.currentUser?.status == "Daddy" {
            //backgroundImage = UIImage(named: "MacDaddy Background_Purple")
            buttonImage = UIImage(named: "MacDaddy Background_Flipped")
            
        }else {
            //backgroundImage = UIImage(named: "MacDaddy Background")
            buttonImage = UIImage(named: "MacDaddy Background_Purple_Flipped")
        }
        
        buttonImage = UIImage(named: "MacDaddy Background_Flipped")
        backgroundImage = UIImage(named: "MacDaddy Background_DarkMode")
        
        
        background.image = backgroundImage
        matchBox.setBackgroundImage(buttonImage, for: .normal)
        
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    
    }
    
    
    //Make the status bar white.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    //IB Actions
    @IBAction func editProfileTapped(_ sender:UIButton){
        
        self.navigationController?.performSegue(withIdentifier: "GoToProfile", sender: nil)
        
        //self.navigationController?.performSegue(withIdentifier: "goToOptions", sender: nil)
    }
    
    @IBAction func worldButtonTapped(_ sender: Any) {
        self.navigationController?.performSegue(withIdentifier: "GoToWorld", sender: nil)
        
    }
    
    @IBAction func findMatchButtonPressed(_ sender: Any) {
        
        // If there is no current match, find a new one!
        // We changed the structure so that your current match is now added to your friends list.
        // DataHandler remembers your current match ID.
        // If you delete your current match, then DataHandler forgets it.
        // If you friend your match, they're a friend, but not a match anymore.
        //
        // If our match is in our friend list and anonymous:
        // We can only request a new match by deleting the old one.
        // We don't want people having too many anonymous matches.
        // Otherwise, if you already deleted them, or they are not anonymous, you are free to get a new match.
        // So logically, pressing the button will get you a new match no matter what.
        // However, it may or may not delete your previous match.
        
        //So the first case scenario is that you are not already chatting a current match.
        //That means currentMatch.uid != anyone in your friends list.
        //So first let's scan through the friends list to see if you are currently chatting a match.
        
        var matched = false
        for friend in DataHandler.friendList {
            if (DataHandler.currentMatchID == friend.uid) && (friend.anon == "1") {
                //This will be used for reference in deletion.
                self.currentMatch = friend
                matched = true
            }
        }
        
        if matched {
            //Alert controller pops up saying: You can only initiate one match at a time.
            //You have three options: Friend your old match, delete your old match, or cancel.
            newMatchAlert()
            
        } else {
           searchForNewMatch()
        }
    }
    
    //Actually initiate the search for a new match:
    func searchForNewMatch() {
        //First edit the button UX:
        matchBox.isEnabled = false
        self.matchBox.setTitle( "Searching...", for: .normal)
        
        //If you're not matched, you'll just get a match.
        Matching.findMatch {
            self.currentMatch = Matching.chosenCandidate
            
            if self.currentMatch.name == "" {
                //If you can't find anyone, keep looking...
                self.matchBox.setTitle( "No matches! Try again later!", for: .normal)
                self.matchBox.isEnabled = true
            } else {
                //If a match is found, start chatting with them!
                self.performSegue(withIdentifier: "PresentNewMatch", sender: self)
            }
        }
    }
    
    func deleteCurrentMatch() {
        //Remove match ID locally
        DataHandler.currentMatchID = ""
        //Remove match ID in Firebase
        DataHandler.updateCurrentMatchID(currentMatchID: "")
        //Remove friendship in Firebase
        DataHandler.deleteFriend(friend: currentMatch, anon: true)
        
        //Sync friends here to update the local list
        //self.syncFriends()
        //This is redundant because the observer will pick up on this anyway and sync the friends
    }
    
    func deleteIncomingMatch(friend: Friend){
        DataHandler.updateUserData(uid: friend.uid, values: ["7: MatchID": ""])
    }
    
    func newMatchAlert() {
        //Alert controller pops up saying: You can only initiate one match at a time.
        //You have three options: Friend your current match, delete your current match, or cancel.
        
        let nickname = currentMatch.name.substring(from: 10)
        
        //Set up the alert controller
        let message = "If you want a new match, you will either have to end your conversation with \(nickname), or tap the heart to add them as a friend. If you both decide to become friends, then you will be able to see each other's names and profile pictures."
        let alert = UIAlertController(title: "You can only initiate one new match at a time.", message: message, preferredStyle: .alert)
        
        // Create the actions
        //Pass: Delete your current match
        let passAction = UIAlertAction(title: "Goodbye, \(nickname).", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            print("Friend passed")
            self.deleteCurrentMatch()
            DataHandler.updateCurrentMatchID(currentMatchID: "")
            
            print("Friend deleted in Firebase")
            self.searchForNewMatch()
            
        }
        //Save your current match by pressing the like button
        let saveAction = UIAlertAction(title: "I want to be friends!", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            Matching.saveCurrentMatch(friend: self.currentMatch)
            self.performSegue(withIdentifier: "ChatWithFriend", sender: self)
            print("Save Pressed")
        }
        //Don't do anything
        let cancelAction = UIAlertAction(title: "I'm not ready to decide.", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alert.addAction(passAction)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


//TableView UI:
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    //How many rows?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //return friends.count
        return DataHandler.friendList.count
    }
    
    //Which cell goes in what row?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendChatCell
        print("🍱 Loading friend \(DataHandler.friendList[indexPath.row])")
        cell.update(with: DataHandler.friendList[indexPath.row])
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = .clear
        
        return cell
    }
    
    //Deleting stuff.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        let friend = DataHandler.friendList[indexPath.row]
        
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
            
            let isAnon = (friend.anon == "1")

            //First just delete them normally
            DataHandler.friendList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            DataHandler.deleteFriend(friend: friend, anon: isAnon)
            
            //If that was your current match, take it out, and remove your current match ID.
            if friend.uid == DataHandler.currentMatchID {
                DataHandler.updateCurrentMatchID(currentMatchID: "")
                print("Deleting current match")
            } else if isAnon {
                //Else, if you were THEIR current match, remove their current match ID.
                //Any anonymous friend that is not your current match must be an incoming match
                self.deleteIncomingMatch(friend: friend)
                print("Deleting incoming match")
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "No, I like \(nickname).", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        if editingStyle == .delete {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//Segues:
extension HomeVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ChatWithFriend" {
            //You're going through the navigation controller first.
//            let navVC = segue.destination as? UINavigationController
//            let destination = navVC?.viewControllers.first as! ChatInterfaceVC
            let destination = segue.destination as! ChatSceneVC
            
            //If you're going from the table, just do it normally.
            //If you're going from the alert controller, go to your current match.
            
            if let selectedRow = tableView.indexPathForSelectedRow?.row {
                destination.friend = DataHandler.friendList[selectedRow]
            } else {
                destination.friend = self.currentMatch
            }
        }

        else if segue.identifier == "PresentNewMatch" {
            //You're also going through the navigation controller first.
            
            //let navVC = segue.destination as? UINavigationController
            //let destination = navVC?.viewControllers.first as! ChatInterfaceVC
            let destination = segue.destination as! ChatSceneVC
            self.currentMatch.anon = "1"
            destination.friend = self.currentMatch

            
        } else if segue.identifier == "goToTempChat"{
            let destination = segue.destination as! MessageInterfaceVC
            
            if let selectedRow = tableView.indexPathForSelectedRow?.row {
                destination.friend = DataHandler.friendList[selectedRow]
            } else {
                destination.friend = self.currentMatch
            }
            
            
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: SegueToLeft) {
        self.matchBox.isEnabled = true
        self.matchBox.setTitle( "Find a match!", for: .normal)
        
        let source = segue.source as! ChatSceneVC
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            DataHandler.friendList[selectedIndexPath.row] = source.friend
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)

        } else {
            let newIndexPath = IndexPath(row: DataHandler.friendList.count, section:0)
            
            //Only add the friend to the list if they are a new friend.
            var newFriend = true
            for friend in DataHandler.friendList {
                if source.friend.convoID == friend.convoID {
                    newFriend = false
                }
            }
            if newFriend {
                DataHandler.friendList.append(source.friend)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromBlock(segue: SegueToLeft) {
        self.matchBox.isEnabled = true
        self.matchBox.setTitle( "Find a match!", for: .normal)
        
        //let source = segue.source as! FriendDetailVC
        tableView.reloadData()
    }
}

