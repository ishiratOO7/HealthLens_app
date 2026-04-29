//
//  String++.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit

extension String {
    
    func localizedLanguage() -> String
    {
        let strLang = "en"
        
        let path = Bundle.main.path(forResource: strLang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}
