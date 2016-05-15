//
//  AppData.swift
//  greggMojica
//
//  Created by Gregg Mojica on 4/29/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit

class AppData {
    var name = ""
    var developer = ""
    var description = ""
    var icon:UIImage?
    var screenShots = [UIImage]()
    
    init(){
        
        let path = NSBundle.mainBundle().pathForResource("AppData", ofType: "json")
        let jsonData =  try! NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
        
        do {
            var json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String:AnyObject]
            
            self.name = json["name"] as! String
            self.developer = json["developer"] as! String
            self.description = json["description"] as! String
            self.icon = UIImage(named: json["icon"] as! String)
            
            for screenShot in json["screenshots"] as! NSArray {
                screenShots.append(UIImage(named: screenShot as! String)!)
            }
        } catch {
            print("error: \(error)")
        }
    }
}