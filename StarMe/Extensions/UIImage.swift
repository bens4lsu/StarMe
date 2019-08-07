//
//  UIImage.swift
//  Velvet Converter
//
//  Created by Ben Schultz on 4/9/19.
//  Copyright © 2019 com.concordbusinessservicesllc. All rights reserved.
//

import UIKit

extension UIImage {
 
    func resize(toWidth width:CGFloat) -> UIImage? {
        // calculate how mch we need to bring the width down to meet our target size
        let scale = width / self.size.width
        let height = self.size.height * scale
        return resize(toSize: CGSize(width: width, height: height))
    }
    
    func resize(toHeight height:CGFloat) -> UIImage? {
        let scale = height / self.size.height
        let width = self.size.width * scale
        return resize(toSize: CGSize(width: width, height: height))
    }
    
    func resize(toSize targetSize: CGSize) -> UIImage? {
        let image = self
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
