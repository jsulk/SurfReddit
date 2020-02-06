//
//  ImageExtension.swift
//  SurfReddit
//
//  Created by Jake Sulkoske on 2/5/20.
//  Copyright © 2020 Jake Sulkoske. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {

    public func getPostImagesAsync(urlString: String) {
        //Set default icon in case there is an issue with the image fetch
        let defaultPostIcon = UIImage(named:"defaultPostImage_icon")?.withRenderingMode(.alwaysTemplate)
        self.tintColor = .lightGray
        self.image = defaultPostIcon
        self.contentMode = .center
        
        //Check to see if thumbnail image is in cache
        if let cachedThumbnail = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.contentMode = .scaleAspectFill
            self.image = cachedThumbnail
            return
        }
        
        let url = urlString.replacingOccurrences(of: " ", with: "+")
        let newUrl = NSURL(string: url)! as URL
        let urlRequest = URLRequest(url: newUrl)
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                print("Error retrieving image")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                if let thumbnailImage = UIImage(data: data!){
                    self.contentMode = .scaleAspectFill
                    imageCache.setObject(thumbnailImage, forKey: urlString as NSString)
                    self.image = thumbnailImage
                }
            })
        }).resume()
        
    }
    
}
