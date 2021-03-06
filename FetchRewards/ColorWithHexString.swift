//
//  ColorWithHexString.swift
//  FetchRewards
//
//  Created by Changhyun Kim on 4/22/21.
//

import Foundation
import UIKit

class ColorWithHexString {
    /**
     Get the hex string and returns UIColor with the hex string applied.
     - Parameter hex: The hex string of the specific color.
     Return: UIColor with the hex string applied.
     */
    func hexStringToUIColor (hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: (.whitespacesAndNewlines) as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
//        if ((cString.characters.count) != 6) {
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
