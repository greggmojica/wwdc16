//
//  DetailViewController.swift
//  wwdc16
//
//  Created by Gregg Mojica on 4/27/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//


import UIKit

class PhotoDetailViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // Properties
    var photo:AppObject?
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photo = photo {
         
            imageView.image = UIImage(named: photo.imageName)
            captionLabel.text = photo.caption
        }
    }
}
