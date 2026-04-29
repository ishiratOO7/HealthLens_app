//
//  HomeScreenUIItem.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//


enum HomeScreenUIItem: String, Equatable, CaseIterable{
    
    case healthScore        =       "Health Score"
    
    var icon: String {
        switch self {
        case .healthScore:
            return ""
        }
    }
}
