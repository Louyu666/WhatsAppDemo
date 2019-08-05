//
//  UIColorExtension.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/4.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Color Builders

public extension UIColor {
    
    convenience init(hex: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex: String = hex
        
        if hex.hasPrefix("#") {
            hex = String(hex[..<hex.index(hex.startIndex, offsetBy: 1)])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch hex.count {
            case 3:
                red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                blue = CGFloat(hexValue & 0x00F) / 15.0
            case 4:
                red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                alpha = CGFloat(hexValue & 0x000F) / 15.0
            case 6:
                red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(hexValue & 0x0000FF) / 255.0
            case 8:
                red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat(hexValue & 0x000000FF) / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be 3, 4, 6 or 8")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func colorWithMinimumSaturation(_ minSaturation: CGFloat) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) =
            (0.0, 0.0, 0.0, 0.0)
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return saturation < minSaturation
            ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
            : self
    }
    
    func alpha(_ value: CGFloat) -> UIColor {
        return withAlphaComponent(value)
    }
}

// MARK: - Helpers

public extension UIColor {
    
    func hex(withPrefix: Bool = true) -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let prefix = withPrefix ? "#" : ""
        
        return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    var isDark: Bool {
        if let RGB = cgColor.components {
            return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
        }
        return false
        
    }
    
    var isBlackOrWhite: Bool {
        if let RGB = cgColor.components {
            return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) ||
                (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
        }
        return false
    }
    
}

// MARK: - Gradient

public extension Array where Element : UIColor {
    
    func gradient(
        _ transform: (( _ gradient: inout CAGradientLayer) -> CAGradientLayer)? = nil
        ) -> CAGradientLayer {
        var gradient = CAGradientLayer()
        gradient.colors = self.map { $0.cgColor }
        
        if let transform = transform {
            _ = transform(&gradient)
        }
        
        return gradient
    }
}
