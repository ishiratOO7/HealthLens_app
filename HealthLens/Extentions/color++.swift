//
//  color+.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        let color = UIColor(named: name.rawValue)
         return color
    }
}

extension UIColor {
    /**
     Convert RGB value to CMYK value.
     - Parameters:
     - r: The red value of RGB.
     - g: The green value of RGB.
     - b: The blue value of RGB.
     
     Returns a 4-tuple that represents the CMYK value converted from input RGB.
     */
    func RGBtoCMYK(r: CGFloat, g: CGFloat, b: CGFloat) -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        
        if r==0, g==0, b==0 {
            return (0, 0, 0, 1)
        }
        var c = 1 - r
        var m = 1 - g
        var y = 1 - b
        let minCMY = min(c, m, y)
        c = (c - minCMY) / (1 - minCMY)
        m = (m - minCMY) / (1 - minCMY)
        y = (y - minCMY) / (1 - minCMY)
        return (c, m, y, minCMY)
    }
    
    /**
     Convert CMYK value to RGB value.
     
     - Parameters:
     - c: The cyan value of CMYK.
     - m: The magenta value of CMYK.
     - y: The yellow value of CMYK.
     - k: The key/black value of CMYK.
     
     Returns a 3-tuple that represents the RGB value converted from input CMYK.
     */
    func CMYKtoRGB(c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let r = (1 - c) * (1 - k)
        let g = (1 - m) * (1 - k)
        let b = (1 - y) * (1 - k)
        return (r, g, b)
    }
    
    func getColorTint() -> UIColor {
        let ciColor = CIColor(color: self)
        let originCMYK = RGBtoCMYK(r: ciColor.red, g: ciColor.green, b: ciColor.blue)
        let kVal = originCMYK.k > 0.3 ? originCMYK.k - 0.2 : originCMYK.k + 0.2
        let tintRGB = CMYKtoRGB(c: originCMYK.c, m: originCMYK.m, y: originCMYK.y, k: kVal)
        return UIColor(red: tintRGB.r, green: tintRGB.g, blue: tintRGB.b, alpha: 1.0)
    }
}
