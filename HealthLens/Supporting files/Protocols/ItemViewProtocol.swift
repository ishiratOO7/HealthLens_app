//
//  ItemViewProtocol.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit


public protocol ItemViewModelProtocol { }

public protocol ItemViewProtocol {
    func updateView(itemViewModel: ItemViewModelProtocol)
}

extension UITableViewCell {
    static func reuseIdentifier() -> String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell {
    static func reuseIdentifier() -> String {
        return String(describing: Self.self)
    }
}

extension UITableViewHeaderFooterView {
    static func reuseIdentifier() -> String {
        return String(describing: Self.self)
    }
}
