//
//  PhotoCollectionViewController.swift
//  wwdc16
//
//  Created by Gregg Mojica on 4/27/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit


private let reuseIdentifier = "photoCell"

class PhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    // Properties
    lazy var photos:[AppObject] = {
        
        return [
            AppObject(title: "/ * Viper */", caption: "Viper was a project I started in my sophomore year of high school.  I worked on it throughout the later half of 2013, and ultimately launched it in the spring of 2014.\n\nViper went crazy at my school with over 900 students signing up within a few days.  Soon after, thousands of students in my city started using the app and it began gaining momentum.  Today, Viper has over 150,000 users around the world.\n\nPrior to viper, I had written several games, utilities, and basic apps, but my experiences with viper taught me the importance of building lasting, emotion-evoking products.  Additionally, it was the first major project I engaged in and prepared me for the ventures to come!  I formed Viper Netowkrs, LLC for this app and in so doing also learned many buisness lessons.\n\nNote, tap the image to learn more or use 3D touch.", imageName: "viper", url: "https://itunes.apple.com/us/app/viper./id831705047?mt=8"),
            AppObject(title: "/ * Nexus */",caption: "Shortly off the heels of Viper, I started working on an app called nexus.  My high school was looking for a simple way to bundle their online services together and approached me to build it. I built nexus free of charge.  It was really incredible to see my work being used by the entire student body, yet again.\n\nToday, Nexus is used by nearly all students at Canisius High School as their go to daily app for information about time orders, schedules, announcements, and more", imageName: "nexus", url: "https://itunes.apple.com/us/app/nexus-canisius/id886419516?mt=8"),
            AppObject(title: "/ * Ride14850 */", caption: "When Cornell University’s Student Agencies, Inc. approached me about updating an existing app to manage their bus systems, I couldn’t refuse.  I worked with a Cornell physics & CS professor to update Ride14850.\n\nEvery day, thousands of students use the app I worked on to navigatie the TCAT bus system at Cornell University.", imageName: "ride14850", url: "https://itunes.apple.com/us/app/ride14850/id461812141?mt=8"),
            AppObject(title: "/ * Gradology */", caption: "Last year, I began working on a new company called Gradology. In partnerhsip with Leo Rocco, a successful San Francisco-based entrepreneur who most recenly sold his last company to Amazon, and Eric Amodeo, a technology adminstrator, I began developing Gradology.\n\nGradology is a social network that allows students to share their academic events with the community and get rewarded based on achievement.\n\nWe're launchig our web platform this summer and mobile app exlusively on iOS this fall.", imageName: "gradology", url: "https://gradology.com"),
            AppObject(title: "/ * Lumen */", caption: "For my high school's open house last year, I built an iOS app called Lumen to interact with a set of Hue light bulbs.  The premise of the app was to help students learn binary code, and was based off Harvard's CS50 course.\n\nLumen is available for free on the app store and also open sourced on GitHub!\n\nAnd of course, it's written entirely in Swift!", imageName: "lumen", url: "https://itunes.apple.com/us/app/lumen-binary-bulbs/id1044673000?mt=8&ign-mpt=uo%3D4"),
            AppObject(title: "/ * Zyp */", caption: "I joined the Zyp team as a remote founding employee and I'm working with a small team to develop an on-demand cleaning startup.\n\nUsing the Zyp platform, customers can easily find safe, effective cleaners in their area and request them on-demand.\n\nZyp is written entirely in Swift 2 and makes use of some the latest APIs in iOS 9!\n\nIt's available as a free download on the app store.", imageName: "zyp", url: "https://itunes.apple.com/us/app/zyp/id976303552?mt=8"),
            AppObject(title: "/ * Slope */", caption: "During the summer of 2015, I became very interested in Augmented Reality (AR) and sought to build an app focused around this technology.\n\nUsing some open sourced frameworks and after researching much about AR technology.\n\nI wrote a simple API using Node.js and the MEAN stack to let people point their phones at landmarks and view information about these landmarks in realtime using augmented reality.", imageName: "slope", url: "https://itunes.apple.com/us/app/slope-see-world-in-augmented/id1003074540?mt=8"),
            AppObject(title: "/ * Pasta Peddler */", caption: "I volunteered my skills to help out a local buisness launch an inventory mamagement app.\n\nUsing various algorithms (including sorting and hashing), this app serves as the hub for the Pasta Peddler's daily inventory. ", imageName: "pastapeddler", url: "Kortrijk"),
            AppObject(title: "/ * uVent */", caption: "uVent is a totally new way to express yourself.n\nAs a iOS developer on the uVent team, I am primarily involved in the design and user experience of the app, which will be launching only on iOS within the next month.\n\nuVent allows anyone share what's on his/her mind in an anonymous, yet secure fashion so people who have something weighing on them can find an uvent outlet to let loose without the fear of being judged.", imageName: "uvent", url: "http://159.203.227.105/home/index"),
            AppObject(title: "/ * Prept */", caption: "This September, as students head back to school, I will launch a new app called Prept.\n\nPrept is an on-demand tutoring platform which connects students and tutors in real time using screensharing and video.\n\nPrept makes use of webRTC, the iOS camera APIs, Apple Pay, and Apple Pencil support, among other iOS APIs. It's almost done and I am plannning on refining it over the summer to get everything ready for launch in the Fall!", imageName: "prept", url: "http://prept.org"),
            ]
        
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = self.collectionView.contentInset
        let value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        self.collectionView.contentInset = insets
        print("\(value)")
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont(name: "Courier", size: 14)
        let leftBarButtonItem = UIBarButtonItem(title: "dismiss()", style: .Plain, target: self, action: #selector(PhotoCollectionViewController.dismissVC))
        leftBarButtonItem.setTitleTextAttributes([NSFontAttributeName:font!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
   
        if( traitCollection.forceTouchCapability == .Available){
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
    }

    func dismissVC() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if( segue.identifier == "myAppDetail" ){
                        let indexPath = collectionView!.indexPathForCell(sender as! UICollectionViewCell)
            let photoObj = photos[indexPath!.row]
            let vc = segue.destinationViewController as! DetailAppViewController
            vc.appObj = photoObj
        }
        
    }
    
    // MARK: UICollectionViewDataSource methods
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        // Configure the cell
        let photo = photos[indexPath.row]
        
        cell.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 3.0,  options: .CurveLinear, animations: {
            cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
           },completion: { finish in
        })

        
        cell.layer.masksToBounds = true;
        cell.layer.cornerRadius = 6;
        
        if let image = UIImage(named: photo.imageName) {
            
            cell.imageView.image = image
            cell.nameLabel.text = photo.title
            cell.detailTextView.text = photo.caption
            
        }else {
            cell.imageView.image = UIImage(named: "image-not-found")
        }
        
        return cell
    }
    
    // MARK: Trait collection delegate methods
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
    
    // MARK: UIViewControllerPreviewingDelegate methods
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView?.indexPathForItemAtPoint(location) else { return nil }
        
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) else { return nil }
        
        guard let detailVC = storyboard?.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as? PhotoDetailViewController else { return nil }
        
        let photo = photos[indexPath.row]
        detailVC.photo = photo
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
    }
    
}
