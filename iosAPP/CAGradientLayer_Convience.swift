//
//  CAGradientLayer_Convience.swift
//  iosAPP
//
//  Created by MIMO on 8/3/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func blueToWhite() -> CAGradientLayer{
        let topColor = UIColor.blueColor()
        let bottomColor = UIColor.whiteColor()
        
        let gradientColors: [CGColor] = [topColor.CGColor,bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0,1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}
