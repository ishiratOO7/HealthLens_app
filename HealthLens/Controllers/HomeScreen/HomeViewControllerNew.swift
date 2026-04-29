//
//  ViewController.swift
//  HealthLens
//
//  Created by Rahul Sharma on 27/04/26.
//

import UIKit

final class HomeViewControllerNew: UIViewController {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = HomeViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HealthLensTheme.Colors.background
        view.tintColor = HealthLensTheme.Colors.gold
        styleDashboard()
        registerCell()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.createUI()
        tableView.reloadData()
    }

    private func styleDashboard() {
        greetingLabel.text = greetingMessage(name: "Rahul")
    }
    
    private func greetingMessage(name: String ) -> String {
        return """
        \(Constent.getWishMessage()), \(name) 👋
        A focused dashboard for your health.
        """
    }
    
}


extension HomeViewControllerNew: UITableViewDataSource, UITableViewDelegate, TableViewProtocol {
    
    func identifierFor(itemViewModel: ItemViewModelProtocol) -> String {
        
        switch itemViewModel {
        case is HealthScoreViewModel:
            return HealthScoreTVCell.reuseIdentifier()
        
        default:
            return HealthScoreTVCell.reuseIdentifier()
        }
    }
    
    func registerCell() {
        
        let cellReuseIdentifiers = [
            HealthScoreTVCell.reuseIdentifier(),
            
        ]
        
        for cellReuseIdentifier in cellReuseIdentifiers {
            tableView.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.internal_numberOfSections(in: tableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.internal_tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = self.internal_tableView(tableView, cellForRowAt: indexPath)
        

//        switch cell {
//        case let healthScoreTVCell as HealthScoreTVCell:
//            healthScoreTVCell.delegate = self
//        
//        default:
//            break
//            
//        }
            
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = .clear
  
        return cell
    }
    
    func tableViewModel() -> ListViewModelProtocol {
        return self.viewModel
    }
  
    
}
