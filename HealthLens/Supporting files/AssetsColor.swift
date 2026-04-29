//
//  AssetsColor.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit
enum AssetsColor: String {
    case AppThemeGreenColor
    
    var color: UIColor {
        return UIColor(named: self.rawValue) ?? .clear
    }
}
