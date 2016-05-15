//
//  DetailAppViewController.swift
//  WWDC16
//
//  Created by Gregg Mojica on 4/21/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import SafariServices


class DetailAppViewController: UIViewController, UIWebViewDelegate {
    
    // IBOutlets
    @IBOutlet var loadingtext: CLTypingLabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var webView: UIWebView!
    
    // Properties
    var appObj:AppObject?
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        if let appObj = appObj {
            
            let url = NSURL (string:appObj.url)
            print("\(url)")
            
            imageView.image = UIImage(named: appObj.imageName)
//            captionLabel.text = appObj.caption
        }
    }
    
    func openLink(link: String) {
        if let url = NSURL(string: link) {
            let vc = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func learnMoreBtnPressed(sender: AnyObject) {
        openLink(appObj!.url)
    }
    
    func webViewDidStartLoad(webView : UIWebView) {
    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        UIView.animateWithDuration(1.0, animations: {
            self.loadingtext.alpha = 0.0
        })
    }
}
