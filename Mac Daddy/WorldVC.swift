//
//  WorldVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 8/17/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class WorldVC: UIViewController, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var worldCollection: UICollectionView!
    @IBOutlet weak var worldCollectionLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worldCollection.delegate = self
        worldCollection.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        
        //Register Nibs
        worldCollection.register(UINib.init(nibName: "MapCell", bundle: nil), forCellWithReuseIdentifier: "MapCell")
        worldCollection.register(UINib.init(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "UserCell")
        
        //Set layout
        if let flow = worldCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        let flowLayout = BouncyLayout(style: .prominent)
        self.worldCollection.setCollectionViewLayout(flowLayout, animated: true)
        
        UserData.downloadAllUsers {
            self.worldCollection.reloadData()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension WorldVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            //Map Cell
            return 1
        default:
            return UserData.allUsers.count
            //Return all the world messages
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = worldCollection.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            return cell
            
        default:
            let cell = worldCollection.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            self.setStructure(for: cell)
            cell.titleLabel.text = UserData.allUsers[indexPath.row].name
            cell.gradeLabel.text = UserData.allUsers[indexPath.row].grade
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
        switch indexPath.section {
        case 0:
            //Map Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 300
            return CGSize(width: width, height: height)
        default:
            //User Cell
            let width = view.bounds.width - 16
            let height: CGFloat = 60
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

