//
//  BadgeViewController.swift
//  WWDC16
//
//  Created by Gregg Mojica on 4/20/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import QuickLook
import MapKit
import Social

class BadgeViewController: UIViewController, QLPreviewControllerDataSource, UIScrollViewDelegate  {

    @IBOutlet var map: MKMapView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var badge: UIImageView!
    var counter: Int = 0;
    var isSmall: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBadge()
        
        self.scrollView.alpha = 0.0
        UIView.animateWithDuration(2.0) { 
            self.scrollView.alpha = 1.0
            self.initialUI()
        }
    }
    
    func initialUI() {
        
        map.showsUserLocation = true
        
        let annotation1 = Annotation(title: "My House",
                                     locationName: "Welcome",
                                     coordinate: CLLocationCoordinate2D(latitude: 42.981038, longitude: -78.737809078))
        map.addAnnotation(annotation1)
        map.layer.cornerRadius = 15
        
        let annotation2 = Annotation(title: "High School",
                                     locationName: "My high school",
                                     coordinate: CLLocationCoordinate2D(latitude: 42.9166170, longitude: -78.8699))
        annotation1.changeColor(true)
        map.addAnnotation(annotation2)
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.5 , 0.5)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.981038, longitude: -79.0377390)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.scrollEnabled = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
       // badge.transform = CGAffineTransformMakeScale(0, 0)

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                    if touch.force >= touch.maximumPossibleForce {
                            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0,  options: .CurveLinear, animations: {
                                    self.badge.transform = CGAffineTransformMakeScale(0.05, 0.05)
                                },completion: { finish in
                                    self.dismissViewControllerAnimated(true, completion: { })
                            })
                    }
                }
            }
        }
    }

    
    func setupBadge() {
        rotateView(badge)
        
        UIView.animateWithDuration(0.4, animations: {
                self.badge.transform = CGAffineTransformMakeScale(0.1, 0.1)},
               completion: { finish in
                UIView.animateWithDuration(0.9){
                    self.badge.transform = CGAffineTransformIdentity
            }
        })
    }
    private func rotateView(targetView: UIView, duration: Double = 0.9) {
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0,  options: .CurveLinear, animations: {
            targetView.transform = CGAffineTransformRotate(targetView.transform, CGFloat(M_PI))
        }) { finished in
            self.counter += 1
        
            if self.counter > 3 { }
            if (self.counter == 3) {
                self.popBadge()
            } else {
                self.rotateView(targetView, duration: duration)
            }
        }
    }
    
    func popBadge() {
        
        UIView.animateWithDuration(0.2, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({

            self.badge.transform = CGAffineTransformMakeScale(1.2, 1.2)

        }), completion: { finish in
            UIView.animateWithDuration(0.2){
                self.badge.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
        })
    }
    @IBAction func learnMore(sender: AnyObject) {
        
    }
    @IBAction func dismissBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressResume(sender: AnyObject) {
        let ql = QLPreviewController()
        ql.dataSource = self
        presentViewController(ql, animated: true, completion: nil)
    }
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int{
        return 1
    }
    
    func previewController(controller: QLPreviewController!, previewItemAtIndex index: Int) -> QLPreviewItem! {
        let mainbundle = NSBundle.mainBundle()
        let url = mainbundle.pathForResource("resume", ofType: "pdf")!
        print(url)
        let doc = NSURL(fileURLWithPath: url)
        return doc
    }

    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        if let navigationController = self.navigationController {
            return navigationController
        } else {
            return self
        }
    }
    
    @IBAction func facebookBtnPressed(sender: AnyObject) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc.setInitialText("Excited for #WWDC")
        presentViewController(vc, animated: true, completion: nil)
        
    }
    @IBAction func twitterBtnPressed(sender: AnyObject) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.setInitialText("Excited for #WWDC")
        presentViewController(vc, animated: true, completion: nil)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}
