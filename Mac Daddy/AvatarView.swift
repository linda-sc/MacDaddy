//
//  AvatarView.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/14/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import UIKit

class AvatarView: UIView {

    @IBOutlet var contentView: AvatarView!
    
    @IBOutlet weak var hair: UIImageView!
    @IBOutlet weak var nose: UIImageView!
    @IBOutlet weak var mouth: UIImageView!
    @IBOutlet weak var mouthShadow: UIImageView!
    @IBOutlet weak var face: UIImageView!
    @IBOutlet weak var faceShadow: UIImageView!
    @IBOutlet weak var shirt: UIImageView!
    @IBOutlet weak var leftArmShadow: UIImageView!
    @IBOutlet weak var leftArm: UIImageView!
    @IBOutlet weak var rightArmShadow: UIImageView!
    @IBOutlet weak var rightArm: UIImageView!
    @IBOutlet weak var neck: UIImageView!
    @IBOutlet weak var hairBottom: UIImageView!

    
    //For using custom view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.layer.isOpaque = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        commonInit()
    }
    
    //For using custom view in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        //fatalError("init(coder:) has not been implemented")
    }
    
    //Initialize the view we designed in the view nib
    private func commonInit() {
        //Tip: make sure the content view is classed as a UIView, and the File's Owner is an AvaterView.
        Bundle.main.loadNibNamed("AvatarView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = UIColor.clear
        contentView.isOpaque = false
        
    }
    
}
