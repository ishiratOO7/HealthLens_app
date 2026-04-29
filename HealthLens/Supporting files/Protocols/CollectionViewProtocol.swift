//
//  CollectionViewProtocol.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit
public protocol CollectionViewProtocol {
    func collectionViewModel() -> ListViewModelProtocol
    func identifierFor(itemViewModel: ItemViewModelProtocol) -> String
    func noDataView(tableView: UICollectionView) -> UIView?
    func internal_numberOfSections(in collectionView: UICollectionView) -> Int
    func internal_collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func internal_collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
public extension CollectionViewProtocol {
    func noDataView(tableView: UICollectionView) -> UIView? {
        return nil
    }

    func internal_numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSection = self.collectionViewModel().numberOfSection()
        return numberOfSection
    }

    func internal_collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewModel().numberOfRowIn(section: section)
    }

    func internal_collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemViewModel = self.collectionViewModel().itemAt(indexPath: indexPath)
        let identifier = self.identifierFor(itemViewModel: itemViewModel)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let itemView = cell as? ItemViewProtocol {
            itemView.updateView(itemViewModel: itemViewModel)
        }
        return cell
    }
}
