//
//  AppsViewController.swift
//  WWDC16
//
//  Created by Gregg Mojica on 4/21/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import AVFoundation

class AppsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var audioObject = GMAudioPlayer()

    let items = ["[", "    'My Apps',", "    'Outreach',", "    'Why WWDC16?',", "    'About Me'","    'Miscellaneous'", "]"]
    
    @IBOutlet weak var welcometext: CLTypingLabel!
    @IBOutlet weak var appsTextView: UITextView!
    @IBOutlet weak var appsLabel: CLTypingLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var visualBlur: UIVisualEffectView!
    
    @IBOutlet var view1: UIVisualEffectView!
    @IBOutlet var view2: UIVisualEffectView!
    let myText = Array("\n\nvar greggMojica = [\n\n\"".characters)
    var ding:AVAudioPlayer = AVAudioPlayer()

    var myCounter = 0
    var timer:NSTimer?
    
    func fireTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.typeLetter), userInfo: nil, repeats: true)
    }
    
    func typeLetter() {
        if myCounter < myText.count {
    
            appsTextView.text = appsTextView.text! + String(myText[myCounter])
            let randomInterval = Double((arc4random_uniform(5)+1))/65
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(randomInterval, target: self, selector: #selector(ViewController.typeLetter), userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
            UIView.animateWithDuration(2.0, animations: {})
        }
        myCounter += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcometext.text = "/*Over the past 4 years, I've worked on a number of apps, websites, books, and widgets. Check out some of my work here.\n\nTap an item to learn more. */"

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                self.userInterface()

                // update some UI
            }
        }
        
        
    }
    
    func userInterface() {
        self.visualBlur.hidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.alpha = 0.0
        UIView.animateWithDuration(1.0, delay: 8.0, options: .CurveEaseInOut, animations: {
            self.tableView.alpha = 1.0
            }, completion: nil)

        
        let myActivity = NSUserActivity(activityType: "com.infinityapps.searchAPIs.detail")
        myActivity.title = "WWDC2016"
        myActivity.eligibleForSearch = true
        myActivity.keywords = Set(arrayLiteral: "Gregg Mojica", "Gregg", "WWDC", "WWDC2016", "San Francisco", "Apple Inc", "DubDub", "The Mothership")
        
        self.userActivity = myActivity
        myActivity.eligibleForHandoff = false
        myActivity.becomeCurrent()
        
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("speak") {

        } else {
            let text = "Hello! My name is Gregg and thank you for taking a look at my WWDC scholarship project.  Click an item in the array to learn more about me."
            audioObject.readAudio(text)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "speak")
        }
        
           }
    
    
    func clickMe() {
        self.visualBlur.hidden = false
        self.visualBlur.alpha = 1.0
        self.visualBlur.frame = self.view.bounds
        self.visualBlur.transform = CGAffineTransformMakeTranslation(0, 200)
        
        let transfrm  = CGAffineTransformMakeScale(0.3, 0.3)
        self.visualBlur.transform = transfrm
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.3,
        initialSpringVelocity: 0.5, options: .CurveLinear, animations: {
        self.visualBlur.transform = CGAffineTransformMakeScale(1, 1);
        self.visualBlur.transform = CGAffineTransformMakeTranslation(0, transfrm.ty + 1)
        }, completion: nil)
        
    }
    
    @IBAction func hideEffect(sender: AnyObject) {
        
            UIView.animateWithDuration(2.0, animations: { 
                self.visualBlur.alpha = 0.0
               // self.visualBlur.hidden = true
            })
        
    }
    
    
    @IBAction func didPressMustaphy(sender: AnyObject) {
        clickMe()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        UIView.animateWithDuration(0.3, delay: 0.4, usingSpringWithDamping: 0.1, initialSpringVelocity: 3.0,  options: .CurveLinear, animations: {
                cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            },completion: { finish in
        })
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        if (cell.textLabel?.text! == "[" || cell.textLabel?.text! == "]" ) {
            cell.textLabel?.textColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    func prepareAudios(fileName: String) {
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")
        do {
            try self.ding = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!), fileTypeHint: nil)
            self.ding.prepareToPlay()
        } catch {
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Index is \(indexPath.row)")
        
        self.prepareAudios("pop")
        self.ding.play()
        
        
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)

        if (indexPath.row == 1) {
            self.performSegueWithIdentifier("appsCollectionSegue", sender: self)
        }
        if (indexPath.row == 2) {
            self.performSegueWithIdentifier("writing", sender: self)
            
        }
        if (indexPath.row == 3) {
            self.performSegueWithIdentifier("wwdc", sender: self)
        }
        if (indexPath.row == 4) {
            self.performSegueWithIdentifier("about", sender: self)
            
        }
        if (indexPath.row == 5)
        {
            clickMe()
        }
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
            self.performSegueWithIdentifier("panorama", sender: self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    // touches moved -- 3D Touch
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                    if touch.force >= touch.maximumPossibleForce {
                        self.dismissViewControllerAnimated(true, completion: { })
                    }
                }
            }
        }
    }
    @IBAction func dismissBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "panorama" {
            let destination = segue.destinationViewController as! PanorificViewController
            destination.image = UIImage(named: "home")
        }
    }
    
}
