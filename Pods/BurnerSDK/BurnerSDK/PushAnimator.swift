//
//  PushAnimator.swift
//  Challenge
//
//  Created by William Carter on 8/29/17.
//  Copyright © 2017 William Carter. All rights reserved.
//

import Foundation
import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.6
    let offset: CGFloat = 100
    var presenting = true
    var navigationControllerOperation: UINavigationControllerOperation?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // the containerView is the superview during the animation process.
        let container = transitionContext.containerView;
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        
        let fromView = fromVC.view
        let toView = toVC.view
        let containerWidth = container.frame.size.width
        
        // Set the needed frames to animate.
        
        var toInitialFrame = container.frame
        var fromDestinationFrame = fromView!.frame
        
        if self.navigationControllerOperation == .push {
            toInitialFrame.origin.x = containerWidth;
            toView?.frame = toInitialFrame;
            fromDestinationFrame.origin.x = -containerWidth;
        }
        else if navigationControllerOperation == .pop
        {
            toInitialFrame.origin.x = -containerWidth;
            toView?.frame = toInitialFrame;
            fromDestinationFrame.origin.x = containerWidth;
        }
        
        // Create a screenshot of the toView.
        guard let move = toView?.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(false)
            return
        }
        
        move.frame = toView!.frame;
        container.addSubview(move)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1000, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            move.frame = container.frame
            fromView!.frame = fromDestinationFrame
            
        }) { (_) in
            
            guard let toView = toView else {
                transitionContext.completeTransition(false)
                return
            }
            
            if !container.subviews.contains(toView) {
                container.addSubview(toView)
            }
            
            toView.frame = container.frame
            fromView?.removeFromSuperview()
            move.removeFromSuperview()
            transitionContext.completeTransition(true)
            
        }
        
    }
    
}
