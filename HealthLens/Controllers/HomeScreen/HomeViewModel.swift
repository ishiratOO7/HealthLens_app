//
//  HomeViewModel.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import Foundation

class HomeViewModel: ListViewModelProtocol{
 
    var sections: [SectionViewModelProtocol] = []
    
    var reloadListData: (() -> Void) = {}
    
    var reloadSections: ((IndexSet) -> Void) = {indexSet in}
    
    var homeScreenItemArray:[HomeScreenUIItem]  {
        return [.healthScore]
    }
    
    func createUI() {
        let section = DefaultSectionViewModel()
        for (_index, cellType) in homeScreenItemArray.enumerated(){
            switch cellType {
            case .healthScore:
                section.items.append(getHealthScore(cellType: cellType))
            }
            
        }
        sections = [section]
    }
    
    
    
    private func getHealthScore(cellType:HomeScreenUIItem) -> HealthScoreViewModel {
        return HealthScoreViewModel(title: cellType.rawValue, subtitle: "Based on your latest report", Score: "78")
    }
    
}
