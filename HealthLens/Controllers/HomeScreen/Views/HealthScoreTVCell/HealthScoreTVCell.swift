
//
//  HealthScoreTVCell.swift
//  HealthLens
//
//  Created by Rahul Sharma on 29/04/26.
//

import UIKit

class HealthScoreTVCell: UITableViewCell {

    @IBOutlet weak var conatinerView: UIView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var subTitleTextLabel: UILabel!
    @IBOutlet weak var chartView: CircularProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    private func setupStyle() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        // Optional: Custom chart colors to match the screenshot
        chartView.progressColor = UIColor(red: 0.40, green: 0.55, blue: 0.65, alpha: 1.0)
        chartView.trackColor = UIColor.systemGray5
        chartView.lineWidth = 8
    }
    
    func configure(with score: String) {
        
        // Convert string to numeric value safely
        let scoreValue = Double(score) ?? 0.0
        
        // 1. Setup the main score text (78 / 100)
        let attributedText = NSMutableAttributedString(
            string: "\(Int(scoreValue))",
            attributes: [
                .font: UIFont.SEMI_BOLD_48,
                .foregroundColor: AssetsColor.AppThemeGreenColor.color
            ]
        )
        
        attributedText.append(NSAttributedString(
            string: " / 100",
            attributes: [
                .font: UIFont.MEDIUM_26,
                .foregroundColor: AssetsColor.AppThemeGreenColor.color
            ]
        ))
        
        scoreLabel.attributedText = attributedText
        
        // 2. Setup the Chart progress safely
        let progress = min(max(scoreValue / 100.0, 0.0), 1.0)
        chartView.setProgress(CGFloat(progress), animated: true)
        
        chartView.setCenterText(
            "\(Int(scoreValue))%",
            font: .systemFont(ofSize: 18, weight: .bold),
            color: UIColor(red: 0.11, green: 0.21, blue: 0.25, alpha: 1.0)
        )
    }
}
extension HealthScoreTVCell: ItemViewProtocol {
    func updateView(itemViewModel: ItemViewModelProtocol){
        if let inputViewModel = itemViewModel as? HealthScoreViewModel {
            configure(with: inputViewModel.score)
            titleTextLabel.text = inputViewModel.title
            subTitleTextLabel.text = inputViewModel.subtitle
            
            titleTextLabel.setUI(font: .MEDIUM_20)
            subTitleTextLabel.setUI(font: .REGULAR_16)
            
        }
    }
}
