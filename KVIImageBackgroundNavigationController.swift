//
//  ImageBackgroundNavigationController.swift
//  LIVEStadium
//
//  Created by Vasyl Khmil on 1/22/16.
//  Copyright © 2016 LIVEStadium. All rights reserved.
//

import UIKit

class KVIImageBackgroundNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    //MARK: Properties(Inspectable)
    
    @IBInspectable var imageName: String?
    
    @IBInspectable var backgroundAlpha: CGFloat = 0.0
    
    @IBInspectable var backgroundColor = UIColor.blackColor()
    
    //MARK: Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        
        if let imageName = self.imageName {
            
            if let imageView = self.imageViewWithImageWithName(imageName) {
                
                self.setupImageView(imageView)
            }
        }
    }
    
    //MARK: Private
    
    private func setupImageView(imageView: UIImageView) {
        imageView.clipsToBounds = true
        
        self.view.addSubview(imageView)
        
        self.view.sendSubviewToBack(imageView)
        
        self.resizeToFullScreenView(imageView)
    }
    
    private func imageViewWithImageWithName(imageName: String) -> UIImageView? {
        
        guard let image = UIImage(named: imageName) else {
            return nil
        }
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .ScaleAspectFill
        
        let backgroundView = self.backgroundView()
        
        imageView.addSubview(backgroundView)
        
        self.resizeToFullScreenView(backgroundView)
        
        return imageView
    }
    
    private func backgroundView() -> UIView {
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = self.backgroundColor
        
        backgroundView.alpha = self.backgroundAlpha
        
        return backgroundView
    }
    
    private func resizeToFullScreenView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let fullScreenConstraints = self.fullScreenConstraintsForView(view)
        
        view.superview?.addConstraints(fullScreenConstraints)
    }
    
    private func fullScreenConstraintsForView(view: UIView) -> [NSLayoutConstraint] {
        let bindings = ["view": view]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options:[], metrics:nil, views: bindings)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options:[], metrics:nil, views: bindings)
        
        return horizontalConstraints + verticalConstraints
    }
    
    private func animatePushFromViewController(viewController: UIViewController) {
        let animationDuration = 0.5
        
        UIView.animateWithDuration(animationDuration,
            
            animations: {
                viewController.view.alpha = 0
                
            },
            
            completion: {
                (_) in
                
                viewController.view.alpha = 1
                
        })
    }
    
    //MARK: UINavigationControllerDelegate
    
    //workaorung to hide top view controller while new one is pushing
    func navigationController(navigationController: UINavigationController,
        animationControllerForOperation operation: UINavigationControllerOperation,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
            if operation == .Push {
                
                self.animatePushFromViewController(fromVC)
            }
            
            return nil
            
    }
}
