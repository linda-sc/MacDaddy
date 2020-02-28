//
//  HomeVC_V2Extension.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/10/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import Firebase

extension HomeVC {
    
    //MARK: Called in ViewDidLoad
    
    func viewDidLoadExtension() {

        UserManager.shared.getLocation()
        UserRequests().checkupUpdates()
        
       
        addGestures()
        setUpCollectionView()
        scripts()
        
        //Add observer to trigger reload
        NotificationCenter.default.addObserver(self, selector: #selector(onDidRecieveUpdatedFriendshipObjects(_:)), name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
        //Add observer to trigger reload
        NotificationCenter.default.addObserver(self, selector: #selector(onDidRecieveUpdatedFriendStructs(_:)), name: .onDidRecieveUpdatedFriendStructs, object: nil)
    
        
    }
    
    //MARK: Other View Functions

    func viewWillAppearExtension() {
        removeFriendshipObserver()
        setUpFriendshipObserver()
    }
    
    func viewWillDisappearExtension(){
        removeFriendshipObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeFriendshipObserver()
    }
        
    
    //MARK: Setting up observers.
    func setUpFriendshipObserver() {
        if FriendshipRequests.queryHandle != nil { return }
        print("Setting up friendship observer")
        FriendshipRequests().observeMyFriendshipObjects { friendships in
            print("Updating UM")
            UserManager.shared.friendships = friendships
        }
    }
    
    func removeFriendshipObserver(){
        print("Removing friendship observer")
        FriendshipRequests().removeFriendshipObserver()
    }
    
    func setUpCollectionView() {
        friendshipCollection.delegate = self
        friendshipCollection.dataSource = self
        
        //Register Nibs
        friendshipCollection.register(UINib.init(nibName: "FriendshipCell", bundle: nil), forCellWithReuseIdentifier: "FriendshipCell")
        
        //Set layout
        if let flow = friendshipCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        let flowLayout = BouncyLayout(style: .prominent)
        self.friendshipCollection.setCollectionViewLayout(flowLayout, animated: true)
        
    }
    
    //MARK: When friendship objects update
    @objc func onDidRecieveUpdatedFriendshipObjects(_ notification:Notification) {
        print("FriendshipObjects updated")
        //self.tableView.reloadData()
        //self.buildHybridObjects()
        self.friendshipCollection.reloadData()
    }
    
    //MARK: When friend structs update

    @objc func onDidRecieveUpdatedFriendStructs(_ notification:Notification) {
        //self.buildHybridObjects()
        self.friendshipCollection.reloadData()
    }
    
    
    //MARK: Swipe to refresh
    
    func addGestures(){
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        downGesture.direction = .down
        self.friendshipCollection.addGestureRecognizer(downGesture)
    }


    @objc func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            print("down gesture")
            //Reload:
            FriendshipRequests().downloadMyFriendshipObjects(completion: {
                friendships in
                UserManager.shared.friendships = friendships
                self.friendshipCollection.reloadData()
                self.refreshActivity()
            })
        }
     }
    
    func refreshActivity() {
        if let myFriendships = UserManager.shared.friendships {
        FriendshipRequests().updateMyLastActiveStatusInAllFriendships(becomingActive: true)
            self.updatedActiveStatusOnce = true
        }
    }
    
    //MARK: Cleanup?
    func scripts(){
            
    }
    
    //MARK: Search for new match
    
     func searchForNewMatch() {
            //First edit the button UI:
            matchBox.isEnabled = false
            self.matchBox.setTitle( "Searching...", for: .normal)
            
            //If you're not matched, you'll just get a match.
            MatchingRequests().initiateMatch(random: true, completion: {
                match in
                
                if match == nil {
                    self.matchBox.setTitle( "No matches! Try again later!", for: .normal)
                    self.matchBox.isEnabled = true
                } else {
                    self.currentMatch = match!.friend
                    self.currentMatchObject = match!.user
                    self.currentFriendshipObject = match!.friendship
                    self.performSegue(withIdentifier: "PresentNewMatch", sender: self)
                }
            })
        }
    
    //MARK: Delete friendship
    
    func deleteFriendship(friendship: FriendshipObject) {
        FriendshipRequests().archiveFriendshipObject(friendship: friendship, completion: { (success) in
            if success {
                let convoId = friendship.convoId
                UserManager.shared.friendships?.removeAll(where: {$0.convoId == convoId})
                self.friendshipCollection.reloadData()
            } else {
                print("Error deleting friendship")
            }
        })
    }
}



//MARK: CollectionView

extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.friendships?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = friendshipCollection.dequeueReusableCell(withReuseIdentifier: "FriendshipCell", for: indexPath) as! FriendshipCell
        cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if let friendship = UserManager.shared.friendships?[indexPath.row] {
            //First update with friendshp
            cell.update(with: friendship)
            //Then update with friend if possible.
            let friendUid = FriendshipRequests().getFriendsUid(friendship: friendship)
            if let friend = FriendshipRequests().fetchCachedFriendStruct(uid: friendUid) {
                cell.update(with: friend)
            } else {
                print("Friend struct- could not be found.")
            }
        }

        self.setStructure(for: cell)
        return cell
    }

    private func setStructure(for cell: UICollectionViewCell) {
          cell.layer.borderWidth = 20
          cell.layer.borderColor = UIColor.clear.cgColor
          cell.layer.cornerRadius = 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               let width = view.bounds.width - 32
               let height: CGFloat = 80
               return CGSize(width: width, height: height)
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select item at.")
        self.performSegue(withIdentifier: "GoToChatFromFriendship", sender: nil)
    }

}


//MARK: Segues

extension HomeVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "GoToChatFromFriendship" {
            let destination = segue.destination as! ChatSceneVC
            
            if let selectedRow = friendshipCollection.indexPathsForSelectedItems?.first?.row {
                
                if let friendship = UserManager.shared.friendships?[selectedRow] {
                    destination.friendship = friendship
                    
                    let friendUid = FriendshipRequests().getFriendsUid(friendship: friendship)
                    if let friend = FriendshipRequests().fetchCachedFriendStruct(uid: friendUid) {
                        destination.friend = friend
                    }
                }
            } else {
                let friend = self.currentMatch
                destination.friend = friend
                if let friendship = FriendshipRequests().fetchCachedFriendship(uid: friend.uid) {
                    destination.friendship = friendship
                }
            }
            
        } else if segue.identifier == "PresentNewMatch" {
            let destination = segue.destination as! ChatSceneVC
            self.currentMatch.anon = "1"
            destination.friend = self.currentMatch
            destination.friendship = self.currentFriendshipObject
            
        } else {
            if let selectedIndexPath = friendshipCollection.indexPathsForSelectedItems?.first {
                friendshipCollection.deselectItem(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: SegueToLeft) {
        self.matchBox.isEnabled = true
        self.matchBox.setTitle( "Find a match!", for: .normal)
        
        let source = segue.source as! ChatSceneVC
        if let selectedIndexPath = friendshipCollection.indexPathsForSelectedItems?.first {
            UserManager.shared.friendships?[selectedIndexPath.row] = source.friendship
            friendshipCollection.reloadItems(at: [selectedIndexPath])

        } else {
            //let newIndexPath = IndexPath(row: 0, section:0)
            
            //Only add the friend to the list if they are a new friend.
            var newFriend = true
            for friend in DataHandler.friendList {
                if source.friend.convoID == friend.convoID {
                    newFriend = false
                }
            }
            if newFriend {
                DataHandler.friendList.append(source.friend)
                self.friendshipCollection.reloadData()
                //tableView.insertRows(at: [newIndexPath], with: .bottom)
                //tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromBlock(segue: SegueToLeft) {
        self.matchBox.isEnabled = true
        self.matchBox.setTitle( "Find a match!", for: .normal)
        
        friendshipCollection.reloadData()
    }
    
    @IBAction func unwindFromPostEngagement(segue: SegueToLeft) {
        friendshipCollection.reloadData()
    }
    

}
