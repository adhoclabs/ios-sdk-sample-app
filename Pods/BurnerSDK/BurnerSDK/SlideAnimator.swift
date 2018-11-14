//
//  SlideAnimator.swift
//  Challenge
//
//  Created by William Carter on 8/25/17.
//  Copyright © 2017 William Carter. All rights reserved.
//

import Foundation
import UIKit

class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.4
    let offset: CGFloat = 100
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if presenting {
        
            let containerView = transitionContext.containerView
            let toView = transitionContext.view(forKey: .to)!
        
            let initialFrame = CGRect(x: 0, y: toView.frame.size.height, width: toView.frame.size.width, height: toView.frame.size.height)
            let finalFrame = toView.frame
        
            toView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY
            )
            
            containerView.addSubview(toView)
            containerView.bringSubview(toFront: toView)
            
            UIView.animate(withDuration: duration, delay:0.0,
                           usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2,
                           animations: {
                            toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                            //fromView.center = CGPoint(x: midFrame.midX, y: midFrame.midY)
            },
                           completion:{_ in
                            transitionContext.completeTransition(true)
            }
            )

            
        } else {
            
            let containerView = transitionContext.containerView
            //let toView = transitionContext.view(forKey: .to)!
            let fromView = transitionContext.view(forKey: .from)!
            
            let initialFrame = CGRect(x: 0, y: 0, width: fromView.frame.size.width, height: fromView.frame.size.height)
            fromView.frame = initialFrame
            
            let finalFrame = CGRect(x: 0, y: fromView.frame.size.height, width: fromView.frame.size.width, height: fromView.frame.size.height)
            
            containerView.addSubview(fromView)
            containerView.bringSubview(toFront: fromView)
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                fromView.frame = finalFrame
                fromView.alpha = 0
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
            
        }
        
    }
    
    
}
