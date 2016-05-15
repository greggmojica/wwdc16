//
//  Photo.swift
//  wwdc16
//
//  Created by Gregg Mojica on 4/25/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit

struct AppObject {

    let caption:String
    let imageName:String
    let title:String
    let url:String
    init(title:String, caption:String, imageName:String, url:String ){
        
        self.caption = caption
        self.imageName = imageName
        self.title = title
        self.url = url
    }
    
}
