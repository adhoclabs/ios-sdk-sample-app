//
//  BurnerNavigationController.swift
//  BurnerSDK
//
//  Created by William Carter on 1/9/18.
//  Copyright © 2018 Burner. All rights reserved.
//

import UIKit

class BurnerNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition = PushAnimator()
        transition.navigationControllerOperation = operation
        
        return transition
        
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        /*if let interactionController = interactionController {
            return interactionController
        }*/
        
        return nil
    }


}
