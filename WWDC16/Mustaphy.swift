//
//  Mustaphy.swift
//  WWDC16
//
//  Created by Gregg Mojica on 4/29/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import Social

class Mustaphy: UIViewController {

    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wwdc-bkg.png")!)

        
        setupFacialUI()
    }
    
    func setupFacialUI() {
        
        let ciImage  = CIImage(CGImage:imageView.image!.CGImage!)
        let ciDetector = CIDetector(ofType:CIDetectorTypeFace
            ,context:nil
            ,options:[
                CIDetectorAccuracy:CIDetectorAccuracyHigh,
                CIDetectorSmile:true
            ]
        )
        let features = ciDetector.featuresInImage(ciImage)
        
        UIGraphicsBeginImageContext(imageView.image!.size)
        imageView.image!.drawInRect(CGRectMake(0,0,imageView.image!.size.width,imageView.image!.size.height))
        
        for feature in features{
            
            //context
            let drawCtxt = UIGraphicsGetCurrentContext()
            
            //face
            var faceRect = (feature as! CIFaceFeature).bounds
            faceRect.origin.y = imageView.image!.size.height - faceRect.origin.y - faceRect.size.height
            
            if (feature as! CIFaceFeature).hasMouthPosition != false{
                let mouseRectY = imageView.image!.size.height - (feature as! CIFaceFeature).mouthPosition.y
                let mouseRect  = CGRectMake((feature as! CIFaceFeature).mouthPosition.x - 5,mouseRectY - 5,10,10)
                CGContextSetStrokeColorWithColor(drawCtxt,UIColor.blueColor().CGColor)
                CGContextStrokeRect(drawCtxt,mouseRect)
            }
            
            //hige
            
            let img = UIImage(named:"mustache.png")
            var higeImg  = img?.imageRotatedByDegrees(180, flip: true)
            
            let x = arc4random_uniform(5)
            print("x is \(x)")
            if x == 0 {
                higeImg = UIImage(named:"stash1")
            }
            if x == 1 {
                higeImg = UIImage(named:"stash2")
            }
            if x == 2 {
                higeImg = UIImage(named:"stash3")
            }
            if x == 3 {
                higeImg = UIImage(named:"stash4")
            }
            if x == 4 {
                higeImg = UIImage(named:"stash5")
            }
            
            let mouseRectY = imageView.image!.size.height - (feature as! CIFaceFeature).mouthPosition.y
            let higeWidth  = faceRect.size.width * 4/5
            let higeHeight = higeWidth * 0.3
            let higeRect  = CGRectMake((feature as! CIFaceFeature).mouthPosition.x - higeWidth/2,mouseRectY - higeHeight/2,higeWidth,higeHeight)
            CGContextDrawImage(drawCtxt,higeRect,higeImg!.CGImage)
            
        }
        let drawedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = drawedImage
    }
    func screenShotMethod() {
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        
        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        composeSheet.setInitialText("I've been mustified #wwdc16!")
        composeSheet.addImage(screenshot)
        
        presentViewController(composeSheet, animated: true, completion: nil)
    }
    
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("Motion began")
        
        refreshView()
    }
    
    func refreshView() ->() {
        
        // Calling the viewDidLoad and viewWillAppear methods to "refresh" the VC and run through the code within the methods themselves
        self.viewDidLoad()
    }

    @IBAction func dismissBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    @IBAction func shareBtnPressed(sender: AnyObject) {
        screenShotMethod()
    }

}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}