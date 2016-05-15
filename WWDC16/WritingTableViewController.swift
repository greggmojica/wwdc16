
//
//  WritingTableViewController.swift
//  WWDC16
//
//  Created by Gregg Mojica on 4/24/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

// NOTE: THIS SERVES AS THE "outreach" tableview

import UIKit
import SafariServices
import CoreMotion

class WritingTableViewController: UITableViewController {
    
    var positionGlobal:CGFloat? = 0
    
    var descriptions = [
        
        "I joined the AppCoda team in August of 2015. Ever since, I've written several iOS articles on a wide variety of topics -- from networking to using new iOS APIs -- and of course, each tutorial covers Swift!\n\nI really enjpoy sharing my knowledge with others and giving back to the iOS community which helped me so much when I was starting off! ",
        
        "Inspiration feed rocks!", "bN", "tiptech", "cornell", "news4", "rome, a quick guide"]
    
    var images = ["appcoda.png", "inspirationfeed.png", "buffalonews.png", "tiptechnews.png", "cornell.png", "news4.png", "rome.png"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "wwdc-bkg"))
        tableView.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func setupNavigationController() {
        let font = UIFont(name: "Courier", size: 14)
        let leftBarButtonItem = UIBarButtonItem(title: "dismiss()", style: .Plain, target: self, action: #selector(WritingTableViewController.dismissVC))
        leftBarButtonItem.setTitleTextAttributes([NSFontAttributeName:font!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    func changeLocation(position:Int) -> Int {
        return position + 50
    }

    func openLink(link: String) {
        if let url = NSURL(string: link) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("index tapped is \(indexPath.row)")
        
        if indexPath.row == 0 {
            openLink("http://www.appcoda.com/author/greggmojica/")
        }
        
        if indexPath.row == 1 {
            openLink("http://inspirationfeed.com/articles/technology-articles/new-years-resolution-learn-how-to-code/")
        }
        
        if indexPath.row == 2 {
            openLink("http://www.buffalonews.com/life-arts/next/a-teens-take-on-the-gadget-everyone-is-talking-about-x2013-the-apple-watch-20150514")
        }
        
        if indexPath.row == 3 {
            openLink("http://www.tiptechnews.com/2013/11/the-ipad-air.html")
        }
        
        if indexPath.row == 4 {
            openLink("http://www.ezraapp.com/")
        }
        
        if indexPath.row == 5 {
            openLink("http://wivb.com/2016/03/15/teen-computer-coding-whiz-considers-building-a-better-buffalo/")
        }
        
        if indexPath.row == 6 {
            openLink("https://itunes.apple.com/us/book/rome-a-quick-guide/id532805321?mt=11")
        }
    }
    
    func dismissVC() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.descriptions.count
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.transform = CGAffineTransformMakeScale(0.3, 0.3);
        cell.alpha = 0.0;
        
        UIView.animateWithDuration(1.0) { 
            cell.alpha = 1.0
        }
     
        cell.nameLabel.text = descriptions[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: images[indexPath.row])
        cell.thumbnailImageView.clipsToBounds = true
        
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(red:0.96, green:0.43, blue:0.23, alpha:1.0)
        }
        
        if indexPath.row == 1 {
            cell.backgroundColor = UIColor(red:0.41, green:0.19, blue:0.57, alpha:1.0)
        }
        
        if indexPath.row == 2 {
            cell.backgroundColor = UIColor(red:0.95, green:0.69, blue:0.21, alpha:1.0)
        }
    
        if indexPath.row == 3 {
            cell.backgroundColor = UIColor(red:0.46, green:0.85, blue:0.7, alpha:1.0)
        }
        
        if indexPath.row == 4 {
            cell.backgroundColor = UIColor(red:0.99, green:0.34, blue:0.33, alpha:1.0)
        }
        
        if indexPath.row == 5 {
            cell.backgroundColor = UIColor(red:0.05, green:0.6, blue:0.99, alpha:1.0)
        }
        
        if indexPath.row == 6 {
            cell.backgroundColor = UIColor(red:0.84, green:0.51, blue:1.0, alpha:1.0)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDetail") {
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}

private extension Int {
    func isNegtive(number:Int) -> Bool {
        if number == -(number) {
            // Pass negatve number -> get positive // YES, it is negative
            return false
        } else {
            // Pass positive number -> gets negative // NO, it is positive
            return true
        }
    }
}

