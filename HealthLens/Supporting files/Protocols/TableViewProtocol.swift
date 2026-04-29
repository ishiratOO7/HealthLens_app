//
//  File.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit

protocol TableViewProtocol: AnyObject {
    func viewModel() -> ListViewModelProtocol
    func identifier(for item: ItemViewModelProtocol) -> String
}

extension TableViewProtocol where Self: UIViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel().numberOfSections()
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel().numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = viewModel().item(at: indexPath)
        let identifier = identifier(for: item)

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        (cell as? ItemViewProtocol)?.updateView(itemViewModel: item)

        return cell
    }
}
