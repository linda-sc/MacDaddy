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
        self.refresh()
        setUpCollectionView()
        
        //Add observer to trigger reload
        NotificationCenter.default.addObserver(self, selector: #selector(onDidRecieveUpdatedFriendshipObjects(_:)), name: .onDidRecieveUpdatedFriendshipObjects, object: nil)
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
    
    //MARK: Function called when logo tapped
    func refresh() {
        if let myFriendships = UserManager.shared.friendships {
            updateMyLastActiveStatus(friendships: myFriendships)
            self.updatedActiveStatusOnce = true
        }
    }

    //MARK: Stuff to do when objects update

    @objc func onDidRecieveUpdatedFriendshipObjects(_ notification:Notification) {
        print("FriendshipObjects updated")
        self.tableView.reloadData()
    }
    
    //MARK: Update your lastActive status
    func updateMyLastActiveStatus(friendships: [FriendshipObject]) {
        print("Updating my last active status in all friendships")
        for friendship in friendships {
            //If I'm the initiator
            if friendship.initiatorId == UserManager.shared.currentUser?.uid {
                friendship.initiatorLastActive = Date()
            } else {
                friendship.recieverLastActive = Date()
            }
            
            FriendshipRequests().updateFriendshipObjectInFirestore(friendship: friendship)
        }
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
        self.setStructure(for: cell)
        return cell
    }
    
    private func setStructure(for cell: UICollectionViewCell) {
          cell.layer.borderWidth = 10
          cell.layer.borderColor = UIColor.clear.cgColor
          cell.layer.cornerRadius = 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               let width = view.bounds.width
               let height: CGFloat = 100
               return CGSize(width: width, height: height)
    }

}
