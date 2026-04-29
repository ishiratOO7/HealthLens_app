//
//  Button+.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit

extension UIButton {
    
    func setUI(text: String? = nil, font: UIFont? = nil, backgroundColor: AssetsColor? = nil, textColor: AssetsColor? = nil) {
        if font != nil {
            self.titleLabel?.font = font!
        }
        if text != nil {
            self.setTitle(text!.localizedLanguage(), for: .normal)
        }
        if backgroundColor != nil {
            self.backgroundColor = UIColor.appColor(backgroundColor!)
        }
        if textColor != nil {
            self.setTitleColor(UIColor.appColor(textColor!), for: .normal)
        }
    }
}
