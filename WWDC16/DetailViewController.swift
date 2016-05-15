
//
//  DetailViewController.swift
//  WWDC16
//
//  Created by Gregg Mojica on 4/20/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet var previewView: UIView!
    @IBOutlet weak var getStarted: UIView!
    @IBOutlet weak var aboutTextLabel: UITextView!
    ///    let myText = Array("Hello, Apple.  Hello, San Francisco. Hello, World.  Hello, WWDC".characters)
    
    let myText = Array("// welcome.swift\n\n1> Hi! I'm Gregg Mojica. I'm a 17 year old high schooler & iOS programmer from Buffalo, New York.\n\n2> I'm an avid programmer, photographer, and writer. I started programming when I was 12 and haven't looked back since. When WWDC was announced this year, the scholarship rules were very different.  Rather than only submit an app I have already worked on, I also decided to write this app to help you get to know me better.  I've included some of the projects I've most proud of in this app, too!\n\nOK, enough about me. Let's get started!\n\n(>_<)\n".characters)
    
    var myCounter = 0
    var timer:NSTimer?
    
    func fireTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.typeLetter), userInfo: nil, repeats: true)
    }
    
    func typeLetter(){

        if myCounter < myText.count {
            
            aboutTextLabel.text = aboutTextLabel.text! + String(myText[myCounter])
            let randomInterval = Double((arc4random_uniform(5)+1))/95
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(randomInterval, target: self, selector: #selector(ViewController.typeLetter), userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
            UIView.animateWithDuration(2.0, animations: {
                self.uiChanges()
            })
        }
        myCounter += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireTimer()
        self.view.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1.0)
//        aboutTextLabel.textColor = UIColor(red:0.99, green:0.59, blue:0.13, alpha:1.0)
    
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
            }
        }
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    override func viewDidDisappear(animated: Bool) {
        timer?.invalidate()
    }
    func uiChanges() {
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 5
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 10
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        getStarted.layer.addAnimation(pulseAnimation, forKey: nil)
    }
    
    
    @IBAction func dismissBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
