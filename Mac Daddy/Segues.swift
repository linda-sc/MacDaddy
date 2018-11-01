//
//  Segues.swift
//  Mac Daddy
//
//  Created by Linda Chen on 7/13/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import Foundation
import UIKit

// These are neccessary because you can't use show and pop if you're switching navigation controllers.
// For this app I'm using JSQMessages controller, and I need a navigation header bar there.
// However, I don't want a navigation bar for my other scenes beacuse the design is different.
// This is tricky because introducing a new navigation controller means it presents and dismisses by default.
// I copied these left and right custom segues from Stack Overflow to fix this problem.

//Unwind:
class UnwindFromLeft: UIStoryboardSegue {
    override func perform() {
        let src = self.source.view as UIView
        let dst = self.destination.view as UIView

        src.superview?.insertSubview(dst, aboveSubview: src)
        dst.transform = CGAffineTransform(translationX: -src.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                delay: 0.0,
                options: UIViewAnimationOptions.curveEaseInOut,
                animations:{dst.transform = CGAffineTransform(translationX: 0, y: 0)},
                
                //Changing this up:
                completion: {
                    (value:Bool) in
                    dst.removeFromSuperview()
                    if let navController = self.destination.navigationController {
                        navController.popToViewController(self.destination, animated: true)
                    }

                }
        )
    }
}

//Like sliding towards the right.
class SegueToRight: UIStoryboardSegue {
    override func perform(){
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
            
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
            
        UIView.animate(withDuration: 0.3,
                delay: 0.0,
                options: UIViewAnimationOptions.curveEaseInOut,
                animations:{dst.view.transform = CGAffineTransform(translationX: 0, y: 0);
                            src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
                },
                completion: { finished in src.present(dst, animated: false, completion: nil)}
        )
    }
}

//Like sliding towards the left.
class SegueToLeft: UIStoryboardSegue{
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations:{dst.view.transform = CGAffineTransform(translationX: 0, y: 0);
                         src.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        },
                       completion: {finished in src.present(dst, animated: false, completion:nil)}
        )
    }
}

class CrossFadeSegue: UIStoryboardSegue {
    override func perform() {

        let window = UIApplication.shared.keyWindow!
        window.insertSubview(destination.view, belowSubview: source.view)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.source.view.alpha = 0.0
            self.destination.view.alpha = 1.0
        }) { (finished) -> Void in
            self.source.view.alpha = 0
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
}

    
