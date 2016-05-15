//
//  PanorificViewController.swift
//  WWDC
//
//  Created by Naji Dmeiri on 9/16/14.
//  Copyright (c) 2014 Naji Dmeiri. All rights reserved.
//

import UIKit
import CoreMotion

class PanorificViewController: UIViewController, UIScrollViewDelegate {
    
    // The image that will be diplayed in the receiver.
    var image: UIImage?
    
    
    // Subviews
    private var panningScrollView: UIScrollView!
    private var panningImageView: UIImageView!
    private var scrollBarView: PanorificScrollBarView!
    
    // Managing Motion Sensing
    private var motionManager: CMMotionManager = CMMotionManager()
    private var motionBasedPanEnabled: Bool = true
    
    // Managing Animation
    private var displayLink: CADisplayLink!
    
    // Contstants
    private let MovementSmoothing: CGFloat = 0.3
    private let AnimationDuration: CGFloat = 0.3
    private let RotationMultiplier: CGFloat = 5.0
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.panningScrollView = UIScrollView(frame: self.view.bounds)
        self.panningScrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.panningScrollView.backgroundColor = UIColor.blackColor()
        self.panningScrollView.delegate = self
        self.panningScrollView.scrollEnabled = false
        self.panningScrollView.alwaysBounceVertical = false
        self.panningScrollView.maximumZoomScale = 2.0
        self.view.addSubview(self.panningScrollView)
        
        self.panningImageView = UIImageView(frame: self.view.bounds)
        self.panningImageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.panningImageView.backgroundColor = UIColor.blackColor()
        self.panningImageView.contentMode = .ScaleAspectFit
        self.panningScrollView.addSubview(self.panningImageView)
        
        self.scrollBarView = PanorificScrollBarView(frame: self.view.bounds, edgeInsets: UIEdgeInsetsMake(0.0, 10.0, 50.0, 10.0))
        self.scrollBarView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.scrollBarView.userInteractionEnabled = false
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(PanorificViewController.displayLinkUpdate(_:)))
        self.displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        
        let button = UIButton(frame: CGRectMake(0, 0, 50, 50))
        button.setImage(UIImage(named: "exit"), forState: UIControlState.Normal)
        
        self.panningScrollView.addSubview(button)
        
        self.configureWithImage(self.image!)
        
        
        
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.whiteColor()
        //        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "/* My House */"
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "dismiss()", style:   UIBarButtonItemStyle.Plain, target: self, action: #selector(PanorificViewController.dismiss))
        
        let font = UIFont(name: "Courier", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName:font!], forState: UIControlState.Normal)

        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.panningScrollView.contentOffset = CGPointMake(
            (self.panningScrollView.contentSize.width / 2.0) - (CGRectGetWidth(self.panningScrollView.bounds)) / 2.0,
            (self.panningScrollView.contentSize.height / 2.0) - (CGRectGetHeight(self.panningScrollView.bounds)) / 2.0
        )
        
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { motion, _ in
            self.calculateRotationBasedOnDeviceMotionRotationRate(motion!)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.image = nil
        
        super.viewDidDisappear(animated)
        
        self.motionManager.stopDeviceMotionUpdates()

    }
    
    deinit {
//        self.displayLink.invalidate()
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Instance methods
    
    func configureWithImage(image: UIImage) {
        self.panningImageView.image = image
        self.updateScrollViewZoomToMaximumForImage(image)
    }
    
    func calculateRotationBasedOnDeviceMotionRotationRate(motion: CMDeviceMotion) {
        if self.motionBasedPanEnabled {
            let xRotationRate = CGFloat(motion.rotationRate.x)
            let yRotationRate = CGFloat(motion.rotationRate.y)
           // let zRotationRate = CGFloat(motion.rotationRate.z)
            
            
            if abs(yRotationRate) > (abs(xRotationRate) ) {
                let invertedYRotationRate = yRotationRate * -1.0
                
                let zoomScale = self.maximumZoomScaleForImage(self.panningImageView.image!)
                let interpretedXOffset = self.panningScrollView.contentOffset.x + invertedYRotationRate * zoomScale * RotationMultiplier
                
                let contentOffset = self.clampedContentOffsetForHorizontalOffset(interpretedXOffset)
                print("Content offset is \(contentOffset)")
                
                UIView.animateWithDuration(NSTimeInterval(MovementSmoothing), delay: 0.0,
                                           options: [.BeginFromCurrentState, .AllowUserInteraction, .CurveEaseOut],
                                           animations: { () -> Void in
                                            self.panningScrollView.setContentOffset(contentOffset, animated: false)
                    },
                                           completion: nil)
            }
        }
    }
    
    func displayLinkUpdate(displayLink: CADisplayLink) {
    }
    
    func maximumZoomScaleForImage(image: UIImage) -> CGFloat {
        print("4")

        return (CGRectGetHeight(self.panningScrollView.bounds) / CGRectGetWidth(self.panningScrollView.bounds)) * (image.size.width / image.size.height)
    }
    
    func updateScrollViewZoomToMaximumForImage(image: UIImage) {
        print("5")

        let zoomScale = self.maximumZoomScaleForImage(image)
        
        self.panningScrollView.maximumZoomScale = zoomScale
        self.panningScrollView.zoomScale = zoomScale
    }
    
    func clampedContentOffsetForHorizontalOffset(horizontalOffset: CGFloat) -> CGPoint {
        let maximumXOffset = self.panningScrollView.contentSize.width - CGRectGetWidth(self.panningScrollView.bounds)
        let minimumXOffset: CGFloat = 0.0
        
        let clampedXOffset = max(minimumXOffset, min(horizontalOffset, maximumXOffset))
        let centeredY = (self.panningScrollView.contentSize.height / 2.0) - (CGRectGetHeight(self.panningScrollView.bounds)) / 2.0
        
        return CGPointMake(clampedXOffset, centeredY)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.panningImageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        print("1")
        scrollView.setContentOffset(self.clampedContentOffsetForHorizontalOffset(scrollView.contentOffset.x), animated: true)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("2")

        if (!decelerate) {
            scrollView.setContentOffset(self.clampedContentOffsetForHorizontalOffset(scrollView.contentOffset.x), animated:true)
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        print("3")

        scrollView.setContentOffset(self.clampedContentOffsetForHorizontalOffset(scrollView.contentOffset.x), animated: true)
    }
}
