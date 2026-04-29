
//
//  Label+.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit

extension UILabel {
    func setUI(text : String? = nil, font : UIFont? = nil, textcolor : AssetsColor? = nil) {
        if text != nil {
            self.text = text!.localizedLanguage()
        }
        if font != nil {
            self.font = font
        }
        if textcolor != nil {
            self.textColor = UIColor.appColor(textcolor!)
        }
    }
}
