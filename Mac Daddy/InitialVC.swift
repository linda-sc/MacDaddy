//
//  InitialVC.swift
//  Mac Daddy
//
//  Created by Linda Chen on 9/28/19.
//  Copyright © 2019 Synestha. All rights reserved.
//

import Foundation
import UIKit

class InitialVC: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "GoToOnboardingStoryboard", sender: self)
              print("Going to onboarding storyboard.")
    }
    
}
