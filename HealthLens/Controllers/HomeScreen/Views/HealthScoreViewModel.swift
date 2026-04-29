//
//  HealthScoreViewModel.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

class HealthScoreViewModel: ItemViewModelProtocol{
    
    let title: String
    let subtitle: String
    let score: String
   
    init(title: String, subtitle: String, Score: String) {
        self.title = title
        self.subtitle = subtitle
        self.score = Score
    }
    
}
