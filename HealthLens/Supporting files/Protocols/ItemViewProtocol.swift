//
//  ItemViewProtocol.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import Foundation


public protocol ItemViewModelProtocol { }

public protocol ItemViewProtocol {
    func updateView(itemViewModel: ItemViewModelProtocol)
}
