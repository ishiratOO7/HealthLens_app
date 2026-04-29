//
//  ViewController.swift
//  HealthLens
//
//  Created by Rahul Sharma on 27/04/26.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private weak var heroCardView: UIView!
    @IBOutlet private weak var heroButton: UIButton!
    @IBOutlet private weak var progressBadgeView: UIView!
    @IBOutlet private weak var firstCardView: UIView!
    @IBOutlet private weak var secondCardView: UIView!
    @IBOutlet private weak var thirdCardView: UIView!
    @IBOutlet private weak var fourthCardView: UIView!

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
    }

    private func styleDashboard() {
        HealthLensTheme.applyHeroCardStyle(to: heroCardView)

        [firstCardView, secondCardView, thirdCardView, fourthCardView].compactMap { $0 }.forEach { cardView in
            let backgroundColor = cardView.backgroundColor ?? HealthLensTheme.Colors.surface
            HealthLensTheme.applyCardStyle(
                to: cardView,
                backgroundColor: backgroundColor,
                borderColor: backgroundColor,
                cornerRadius: 22
            )
        }

        progressBadgeView.layer.cornerRadius = 40
        progressBadgeView.layer.cornerCurve = .continuous
        progressBadgeView.layer.borderWidth = 8
        progressBadgeView.layer.borderColor = HealthLensTheme.Colors.goldSoft.cgColor

        var configuration = UIButton.Configuration.filled()
        configuration.title = "View task"
        configuration.baseBackgroundColor = HealthLensTheme.Colors.gold
        configuration.baseForegroundColor = HealthLensTheme.Colors.tealDark
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        configuration.titleTextAttributesTransformer = HealthLensTheme.textAttributesTransformer(
            font: HealthLensTheme.Fonts.button(15),
            color: HealthLensTheme.Colors.tealDark
        )
        heroButton.configuration = configuration
    }
}
