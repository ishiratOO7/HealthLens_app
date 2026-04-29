//
//  CommonMethods.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit

class Constent{
    
    
    class func getWishMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        let greeting: String
        
        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<21:
            greeting = "Good Evening"
        default:
            greeting = "Hello"
        }
        
        return greeting
    }

}
