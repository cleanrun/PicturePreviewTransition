//
//  TransitionManager.swift
//  PicturePreviewTransition
//
//  Created by cleanmac on 29/06/23.
//

import UIKit

/// A class to animate navigation transitions using custom animation logic.
/// This class was based on this article: https://medium.com/geekculture/custom-view-controllers-transitions-aa8c052f8049
final class TransitionManager: NSObject {
    
    /// The duration of the transition process.
    private let duration: TimeInterval
    
    /// A flag to indicate the navigation operation.
    private var operation: UINavigationController.Operation = .push
    
    private let bounceValue: CGFloat = 0.25
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    /// Animates the transition based on the current navigation operation.
    /// - Parameters:
    ///   - fromVC: The beginning view controller for the transition.
    ///   - toVC: The end view controller for the transition.
    ///   - context: A set of methods that provide contextual information for transition animations between view controllers.
    private func animateTransition(from fromVC: UIViewController, to toVC: UIViewController, using context: UIViewControllerContextTransitioning) {
        switch operation {
        case .push:
            guard let listVC = fromVC as? ImageListViewController, let previewVC = toVC as? ImagePreviewViewController
            else { return }
            animatePresent(to: previewVC, from: listVC, using: context)
        case .pop:
            guard let previewVC = fromVC as? ImagePreviewViewController, let listVC = toVC as? ImageListViewController
            else { return }
            animateDismiss(from: previewVC, to: listVC, using: context)
        default:
            break
        }
    }
    
    /// Animates the presentation operation between 2 view controllers.
    /// - Parameters:
    ///   - toVC: The end view controller for the transition.
    ///   - fromVC: The beginning view controller for the transition.
    ///   - context: A set of methods that provide contextual information for transition animations between view controllers.
    private func animatePresent(to toVC: ImagePreviewViewController, from fromVC: ImageListViewController, using context: UIViewControllerContextTransitioning) {
        guard let selectedCell = fromVC.selectedCell else { return }
        
        // This needs to be called because the end view controller's subviews is not yet laid out,
        // so we need to call this to get the positions and frames of each of its subviews.
        toVC.view.layoutIfNeeded()
        
        let cellImageView = selectedCell.contentImageView
        let previewImageView = toVC.contentImageView
        
        let containerView = context.containerView
        
        let snapshotContainerView = UIView()
        snapshotContainerView.backgroundColor = .black
        snapshotContainerView.alpha = 0
        snapshotContainerView.frame = containerView.convert(toVC.view.frame, from: toVC.view)
        
        let snapshotImageView = UIImageView()
        snapshotImageView.clipsToBounds = true
        snapshotImageView.contentMode = cellImageView.contentMode
        snapshotImageView.image = cellImageView.image
        snapshotImageView.frame = containerView.convert(cellImageView.frame, from: selectedCell.contentView)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshotContainerView)
        containerView.addSubview(snapshotImageView)
        
        toVC.view.isHidden = true
        
        if #available(iOS 17.0, *) {
            defer {
                fromVC.selectedCell?.isHidden = true
            }
            
            UIView.animate(springDuration: duration, bounce: bounceValue, animations: {
                snapshotContainerView.alpha = 1
                snapshotImageView.frame = containerView.convert(previewImageView.frame, to: toVC.view)
                snapshotImageView.contentMode = previewImageView.contentMode
            }, completion: { _ in
                toVC.view.isHidden = false
                snapshotContainerView.removeFromSuperview()
                snapshotImageView.removeFromSuperview()
                context.completeTransition(true)
            })
        } else {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
                snapshotContainerView.alpha = 1
                snapshotImageView.frame = containerView.convert(previewImageView.frame, to: toVC.view)
                snapshotImageView.contentMode = previewImageView.contentMode
            }
            
            animator.addCompletion { position in
                toVC.view.isHidden = false
                snapshotContainerView.removeFromSuperview()
                snapshotImageView.removeFromSuperview()
                context.completeTransition(position == .end)
            }
            
            animator.startAnimation()
        }
    }
    
    /// Animates the dismissal operation between 2 view controllers.
    /// - Parameters:
    ///   - fromVC: The beginning view controller for the transition.
    ///   - toVC: The end view controller for the transition.
    ///   - context: A set of methods that provide contextual information for transition animations between view controllers.
    private func animateDismiss(from fromVC: ImagePreviewViewController, to toVC: ImageListViewController, using context: UIViewControllerContextTransitioning) {
        guard let selectedCell = toVC.selectedCell else { return }
        
        let previewImageView = fromVC.contentImageView
        let cellImageView = selectedCell.contentImageView
        
        let containerView = context.containerView
        
        let snapshotContainerView = UIView()
        snapshotContainerView.backgroundColor = .black
        snapshotContainerView.alpha = 1
        snapshotContainerView.frame = containerView.convert(fromVC.view.frame, from: fromVC.view)
        
        let snapshotImageView = UIImageView()
        snapshotImageView.clipsToBounds = true
        snapshotImageView.contentMode = previewImageView.contentMode
        snapshotImageView.image = previewImageView.image
        snapshotImageView.frame = containerView.convert(previewImageView.frame, from: fromVC.view)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshotContainerView)
        containerView.addSubview(snapshotImageView)
        
        toVC.view.isHidden = false
        
        if #available(iOS 17.0, *) {
            defer {
                toVC.selectedCell?.isHidden = false
            }
            
            UIView.animate(springDuration: duration, bounce: bounceValue, animations: {
                snapshotContainerView.alpha = 0
                snapshotImageView.frame = containerView.convert(cellImageView.frame, from: selectedCell.contentView)
                snapshotImageView.contentMode = cellImageView.contentMode
                snapshotImageView.layer.cornerRadius = cellImageView.layer.cornerRadius
            }, completion: { _ in
                snapshotContainerView.removeFromSuperview()
                snapshotImageView.removeFromSuperview()
                context.completeTransition(true)
            })
        } else {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
                snapshotContainerView.alpha = 0
                snapshotImageView.frame = containerView.convert(cellImageView.frame, from: selectedCell.contentView)
                snapshotImageView.contentMode = cellImageView.contentMode
                snapshotImageView.layer.cornerRadius = cellImageView.layer.cornerRadius
            }
            
            animator.addCompletion { position in
                snapshotContainerView.removeFromSuperview()
                snapshotImageView.removeFromSuperview()
                context.completeTransition(position == .end)
            }
            
            animator.startAnimation()
        }
    }
    
}

extension TransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        animateTransition(from: fromVC, to: toVC, using: transitionContext)
    }
}

extension TransitionManager: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operation = operation
        return self
    }
}
