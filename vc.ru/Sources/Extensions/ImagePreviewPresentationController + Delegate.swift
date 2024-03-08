//
//  ImagePreviewPresentationController + Delegate.swift
//  vc.ru
//
//  Created by Максим Митрофанов on 22.02.2024.
//

import UIKit

class ImagePreviewPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else { return }
        
        // Customize the frame of the presented view controller here
        // For example, to center the image view with some padding
        let frame = containerView.bounds
        presentedView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        presentedView?.clipsToBounds = true
    }
}

class ImagePreviewTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var originFrame = CGRect.zero

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ImagePreviewPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ImageTransitionAnimator()
        animator.originFrame = originFrame
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ImageTransitionAnimator()
        animator.originFrame = originFrame
        animator.isPresenting = false
        return animator
    }
}

class ImageTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame = CGRect.zero
    var isPresenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = isPresenting ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from),
              let imageView = isPresenting ? (transitionContext.viewController(forKey: .to) as? ImagePreviewViewController)?.imageView : (transitionContext.viewController(forKey: .from) as? ImagePreviewViewController)?.imageView else {
            transitionContext.completeTransition(false)
            return
        }
        
        let initialFrame = isPresenting ? originFrame : imageView.frame
        let finalFrame = isPresenting ? imageView.frame : originFrame
        
        let xScaleFactor = isPresenting ?
        initialFrame.width / finalFrame.width :
        finalFrame.width / initialFrame.width
        
        let yScaleFactor = isPresenting ?
        initialFrame.height / finalFrame.height :
        finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if isPresenting {
            containerView.addSubview(toView)
            imageView.transform = scaleTransform
            imageView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
        }
        
        imageView.clipsToBounds = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.transform = self.isPresenting ? .identity : scaleTransform
            imageView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            if !self.isPresenting {
                containerView.addSubview(toView)
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
