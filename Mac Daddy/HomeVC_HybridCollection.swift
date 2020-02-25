//
//  HomeVC_HybridCollection.swift
//  Mac Daddy
//
//  Created by Linda Chen on 2/24/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import UIKit

//MARK: CollectionView

//Tripartite structure to hold all three representations
 struct HybridObject {
    var friend = Friend()
    var user = UserObject()
    var friendship = FriendshipObject()
    var lastActive = Date()
 }


//extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    //MARK: Fetching data in reload, not cells :)
//    func buildHybridObjects(){
//        var tempList = [HybridObject]()
//
//        for friend in DataHandler.friendList {
//            let uid = friend.uid
//            let friendship = FriendshipRequests().fetchCachedFriendship(uid: uid)
//
//            var hybridObject = HybridObject()
//
//            hybridObject.friend = friend
//            hybridObject.friendship = friendship ?? FriendshipObject()
//
//            tempList.append(hybridObject)
//
//            let oldDate = Date(timeIntervalSince1970: 0)
//            hybridObject.lastActive = friendship?.lastActive ?? oldDate
//        }
//
//        UserManager.hybridObjects = tempList.sorted(by: {
//            $0.lastActive.compare(
//                $1.lastActive) == .orderedDescending
//        })
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return UserManager.hybridObjects?.count ?? 0
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = friendshipCollection.dequeueReusableCell(withReuseIdentifier: "FriendshipCell", for: indexPath) as! FriendshipCell
//        cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        if let hybrid = UserManager.hybridObjects?[indexPath.row] {
//            let friendship = hybrid.friendship
//            let friend = hybrid.friend
//            //First update with friendshp
//            cell.update(with: friendship)
//            //Then update with friend if possible.
//            cell.update(with: friend)
//        }
//        self.setStructure(for: cell)
//        return cell
//    }
//
//    private func setStructure(for cell: UICollectionViewCell) {
//          cell.layer.borderWidth = 20
//          cell.layer.borderColor = UIColor.clear.cgColor
//          cell.layer.cornerRadius = 20
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//               let width = view.bounds.width - 32
//               let height: CGFloat = 80
//               return CGSize(width: width, height: height)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Did select item at.")
//        self.performSegue(withIdentifier: "GoToChatFromFriendship", sender: nil)
//    }
//
//}
//
////MARK: Segues
//
//extension HomeVC {
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "GoToChatFromFriendship" {
//            let destination = segue.destination as! ChatSceneVC
//
//            if let selectedRow = friendshipCollection.indexPathsForSelectedItems?.first?.row {
//                if let hybrid = UserManager.hybridObjects?[selectedRow] {
//                    destination.friendship = hybrid.friendship
//                    destination.friend = hybrid.friend
//                }
//            } else {
//                let friend = self.currentMatch
//                destination.friend = friend
//                if let friendship = FriendshipRequests().fetchCachedFriendship(uid: friend.uid) {
//                    destination.friendship = friendship
//                }
//            }
//
//        } else if segue.identifier == "PresentNewMatch" {
//            let destination = segue.destination as! ChatSceneVC
//            self.currentMatch.anon = "1"
//            destination.friend = self.currentMatch
//            destination.friendship = self.currentFriendshipObject
//
//        } else {
//            if let selectedIndexPath = friendshipCollection.indexPathsForSelectedItems?.first {
//                friendshipCollection.deselectItem(at: selectedIndexPath, animated: true)
//            }
//        }
//    }
//
//    @IBAction func unwindFromDetail(segue: SegueToLeft) {
//        self.matchBox.isEnabled = true
//        self.matchBox.setTitle( "Find a match!", for: .normal)
//
//        let source = segue.source as! ChatSceneVC
//        if let selectedIndexPath = friendshipCollection.indexPathsForSelectedItems?.first {
//            //UserManager.shared.friendships?[selectedIndexPath.row] = source.friendship
//            friendshipCollection.reloadItems(at: [selectedIndexPath])
//
//        } else {
//            //let newIndexPath = IndexPath(row: 0, section:0)
//
//            //Only add the friend to the list if they are a new friend.
//            var newFriend = true
//            for friend in DataHandler.friendList {
//                if source.friend.convoID == friend.convoID {
//                    newFriend = false
//                }
//            }
//            if newFriend {
//                DataHandler.friendList.append(source.friend)
//                self.friendshipCollection.reloadData()
//                //tableView.insertRows(at: [newIndexPath], with: .bottom)
//                //tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
//            }
//        }
//    }
//
//
//    @IBAction func unwindFromBlock(segue: SegueToLeft) {
//           self.matchBox.isEnabled = true
//           self.matchBox.setTitle( "Find a match!", for: .normal)
//
//           friendshipCollection.reloadData()
//       }
//
//    @IBAction func unwindFromPostEngagement(segue: SegueToLeft) {
//           friendshipCollection.reloadData()
//       }
//}
