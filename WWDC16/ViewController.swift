//
//  ViewController.swift
//  WWDC16
//
//  Created by Gregg Mojica on 4/19/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var wwdcTextLabel: UILabel!
    @IBOutlet var detailDubDubText: UITextView!
    @IBOutlet var dubDubLogo: UIImageView!
    @IBOutlet var openAppBtn: UIButton!
    
    let typewriterText = Array("xcrun swift lldb --repl\n/* Created on 19 April 2016 by Gregg Mojica */\n\nHello, Apple.  Hello, Swift. Hello California. Hello, San Francisco. Hello, World.  Hello, WWDC.".characters)
    
    var myCounter = 0
    var timer:NSTimer?
    
    func fireTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.typeLetter), userInfo: nil, repeats: true)
    }
    
    func typeLetter(){
        if myCounter < typewriterText.count {
            detailDubDubText.text = detailDubDubText.text! + String(typewriterText[myCounter])
            let randomInterval = Double((arc4random_uniform(5)+1))/55 // 35
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(randomInterval, target: self, selector: #selector(ViewController.typeLetter), userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
            UIView.animateWithDuration(2.0, animations: {
                self.dubDubLogo.alpha = 1.0
                self.openAppBtn.alpha = 1.0
                self.uiChanges()
            })
        }
        myCounter += 1
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dubDubLogo.alpha = 0.0
        self.openAppBtn.alpha = 0.0
        self.view.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1.0);

        fireTimer()
    }
    
    func uiChanges() {
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 4
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 10
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 4
        openAppBtn.layer.addAnimation(pulseAnimation, forKey: nil)
    }
 
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}

