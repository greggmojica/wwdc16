//
//  ViewController.swift
//  UIScrollViewOnStoryBoardSample
//
//  Created by Gregg Mojica on 4/29/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit

class WhyDubDubUIViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var developerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var innerScrollView: UIScrollView!
    var invisibleScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let myText = Array("/* Ever since I was 13 years old, I have always been a huge Apple Fan.  Every year, I've made it a habit to watch the WWDC keynote.  I've viewed past WWDC sessions, followed #wwdc on twitter closely, and have always kept a keen eye on everything WWDC.  In short, I’ve been OBSESSED with WWDC!\n\nSince I first put my hands on an Apple device in 2006 (an iMac), I've fallen in love with what Apple has done.  Steve Jobs has for a long time been one of my idols and a person I look up to and respect.  His impact is only second in my life to that of my grandpa (who passed away earlier this year).  Both my grandpa and Steve Jobs made a lasting impact on the people they interacted with and also the community at large.  I aspire to one day have such an impact and feel I can only do so through technology.\n\nAttending WWDC16 would mean a LOT to me.  I feel attending WWDC16 would be an incredibly unique chance to become a better programmer, learn invaluable techniques, ask my questions to outstanding engineers, and most of all, meet other like minded people.  Living in Buffalo, we do not have a huge developer community, and many of the people I have met are either out of state or even out of the country.  WWDC would expose me to so much more and I would be so deeply grateful to Apple if you choose to afford me this opportunity.\n\nThank you so very much for taking the time to go through my WWDC app.  I hope to see you in June! :)\n\n-gregg */".characters)
    
    var myCounter = 0
    var timer:NSTimer?
    
    func fireTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.typeLetter), userInfo: nil, repeats: true)
    }
    
    func typeLetter(){
        if myCounter < myText.count {
            
            descriptionLabel.text = descriptionLabel.text! + String(myText[myCounter])
            let randomInterval = Double((arc4random_uniform(5)+1))/65
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(randomInterval, target: self, selector: #selector(ViewController.typeLetter), userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
        }
        myCounter += 1
    }
    
    
    let appData = AppData.init()
    
    let imageViewSize = 280.0
    var imageOffset = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireTimer()
        iconImageView.image = appData.icon
        appNameLabel.text = appData.name
        developerNameLabel.text = "Gregg Mojica"
        setScreenShotImages()
    }
    
    func setScreenShotImages(){
        
        imageOffset = (Double(self.view.frame.size.width) - imageViewSize) / 2.0
        
        innerScrollView.contentSize = CGSize(width: CGFloat(imageOffset + imageViewSize * Double(appData.screenShots.count)) , height: innerScrollView.frame.size.height)
        
        invisibleScrollView = UIScrollView(frame: CGRect(x: CGFloat(imageOffset), y: 0,
            width: CGFloat(imageViewSize), height: innerScrollView.frame.size.height))
        invisibleScrollView.userInteractionEnabled = false
        invisibleScrollView.pagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        invisibleScrollView.showsVerticalScrollIndicator = false
        invisibleScrollView.contentSize = CGSize(width: innerScrollView.contentSize.width - CGFloat(imageOffset), height:innerScrollView.contentSize.height)
        
        innerScrollView.addGestureRecognizer(invisibleScrollView.panGestureRecognizer);
        
        self.view.addSubview(invisibleScrollView)
        
        invisibleScrollView.delegate = self;
        
        self.pageControl.numberOfPages = appData.screenShots.count
    
        
        for index in 0 ..< appData.screenShots.count {
            let containerView = UIView(frame: CGRect(x: CGFloat(imageOffset + imageViewSize * Double(index)), y: 0,
                width: CGFloat(imageViewSize), height: innerScrollView.frame.size.height))
         
            innerScrollView.addSubview(containerView)
            
            let screenShot:UIImageView? = UIImageView(image: appData.screenShots[index])
            screenShot!.clipsToBounds = true

            containerView.alpha = 0.0
            UIView.animateWithDuration(5.0) {
                containerView.alpha = 1.0
            }

            
            //for landscape image
            if (screenShot!.image?.size.height<screenShot!.image?.size.width){
                let degrees = CGFloat(90.0)
                let cgf180 = CGFloat(180)
                screenShot!.transform = CGAffineTransformMakeRotation(degrees * CGFloat(M_PI)/cgf180);
            }
            
            screenShot!.frame.size = CGSize(width: 300, height: 300)
            screenShot!.contentMode = UIViewContentMode.ScaleAspectFit
            screenShot!.center = CGPoint(x:containerView.frame.size.width/2, y:containerView.frame.size.height/2+10)
            
            containerView.addSubview(screenShot!)
            
        }
    }
    
    @IBAction func didDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func scrollViewDidScroll(scrollview: UIScrollView) {
        
        let pageWidth : CGFloat = self.invisibleScrollView.frame.size.width
        let fractionalPage : Double = Double(self.invisibleScrollView.contentOffset.x / pageWidth)
        let page : NSInteger = lround(fractionalPage)
        self.pageControl.currentPage = page;
    
        self.innerScrollView.contentOffset = self.invisibleScrollView.contentOffset;
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

