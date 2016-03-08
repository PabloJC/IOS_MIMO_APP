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
        let topColor = UIColor(red: 78, green: 159, blue: 255, alpha: 0)
        let bottomColor = UIColor.whiteColor()
        
        let gradientColors: [CGColor] = [topColor.CGColor,bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0,1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}

extension UIView {
    func addBorderTop(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    func addBorderBottom(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    func addBorderLeft(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    func addBorderRight(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    private func addBorderUtility(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
}
