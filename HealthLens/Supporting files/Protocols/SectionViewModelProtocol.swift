//
//  SectionViewModelProtocol.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import Foundation
public protocol SectionViewModelProtocol: AnyObject {
    var items: [ItemViewModelProtocol] { get set }

    func numberOfRows() -> Int
    func item(at index: Int) -> ItemViewModelProtocol

    func insertItem(_ item: ItemViewModelProtocol, at index: Int)
    func deleteItem(at index: Int) -> ItemViewModelProtocol
}

final class SectionViewModel: SectionViewModelProtocol {

    var items: [ItemViewModelProtocol] = []

    init(items: [ItemViewModelProtocol] = []) {
        self.items = items
    }

    func numberOfRows() -> Int {
        return items.count
    }

    func item(at index: Int) -> ItemViewModelProtocol {
        return items[index]
    }

    func insertItem(_ item: ItemViewModelProtocol, at index: Int) {
        items.insert(item, at: index)
    }

    func deleteItem(at index: Int) -> ItemViewModelProtocol {
        return items.remove(at: index)
    }
}


