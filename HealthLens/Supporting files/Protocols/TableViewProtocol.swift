//
//  File.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit

public protocol TableViewProtocol {
    func tableViewModel() -> ListViewModelProtocol
    func identifierFor(itemViewModel: ItemViewModelProtocol) -> String
    func noDataView(tableView: UITableView) -> UIView?
    func internal_numberOfSections(in tableView: UITableView) -> Int
    func internal_tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func internal_tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func internal_tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func internal_deleteRow(tableView: UITableView, at indexPaths: [IndexPath],with animation: UITableView.RowAnimation)
    func internal_insertRow(tableView: UITableView, at indexPaths: [IndexPath],with animation: UITableView.RowAnimation)
}

public extension TableViewProtocol {
    func noDataView(tableView: UITableView) -> UIView? {
        return nil
    }

    func internal_numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSection = self.tableViewModel().numberOfSection()
        tableView.tableHeaderView = numberOfSection > 0 ? nil : self.noDataView(tableView: tableView)
        return numberOfSection
    }

    func internal_tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewModel().numberOfRowIn(section: section)
    }

    func internal_tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemViewModel = self.tableViewModel().itemAt(indexPath: indexPath)
        let identifier = self.identifierFor(itemViewModel: itemViewModel)
//        print(#function,itemViewModel,identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let itemView = cell as? ItemViewProtocol {
            itemView.updateView(itemViewModel: itemViewModel)
        }
        return cell
    }
    func internal_insertRow(tableView: UITableView, at indexPaths: [IndexPath],with animation: UITableView.RowAnimation) {
        tableView.performBatchUpdates({
            tableView.insertRows(at: indexPaths, with: animation)
        }, completion: nil)
    }
    func internal_deleteRow(tableView: UITableView, at indexPaths: [IndexPath],with animation: UITableView.RowAnimation) {
        self.tableViewModel().deleteIteamAt(indexPaths: indexPaths)
        tableView.performBatchUpdates({
            tableView.deleteRows(at: indexPaths, with: animation)
        }, completion: nil)
    }
    func internal_tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let moveRowItem = self.tableViewModel().deleteIteamAt(indexPaths: [sourceIndexPath]).first {
            self.tableViewModel().insertItemAt(indexPath: destinationIndexPath, model: moveRowItem)
        }
    }
}
