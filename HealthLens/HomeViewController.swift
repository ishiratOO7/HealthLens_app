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

    @IBOutlet private weak var tabBarView: UIView!
    @IBOutlet private var tabButtons: [UIButton]!

    private var selectedTabIndex = 0

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
        styleTabBar()
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

    private func styleTabBar() {
        tabButtons = tabButtons.sorted { $0.tag < $1.tag }

        tabBarView.backgroundColor = HealthLensTheme.Colors.surface
        tabBarView.layer.cornerRadius = 28
        tabBarView.layer.cornerCurve = .continuous
        tabBarView.layer.borderWidth = 1
        tabBarView.layer.borderColor = HealthLensTheme.Colors.border.cgColor
        tabBarView.layer.shadowColor = HealthLensTheme.Colors.shadow.cgColor
        tabBarView.layer.shadowOpacity = 0.18
        tabBarView.layer.shadowRadius = 22
        tabBarView.layer.shadowOffset = CGSize(width: 0, height: 12)
        tabBarView.layer.masksToBounds = false

        tabButtons.forEach(configureTabButton(_:))
        selectTab(at: selectedTabIndex)
    }

    private func configureTabButton(_ button: UIButton) {
        var configuration = UIButton.Configuration.plain()
        configuration.title = button.title(for: .normal)
        configuration.image = button.image(for: .normal)
        configuration.imagePlacement = .top
        configuration.imagePadding = 4
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 4, bottom: 6, trailing: 4)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        configuration.titleTextAttributesTransformer = HealthLensTheme.textAttributesTransformer(
            font: HealthLensTheme.Fonts.bodyMedium(11)
        )
        button.configuration = configuration
    }

    @IBAction private func tabBarItemTapped(_ sender: UIButton) {
        selectTab(at: sender.tag)
    }

    private func selectTab(at index: Int) {
        guard tabButtons.indices.contains(index) else { return }
        selectedTabIndex = index

        for button in tabButtons {
            let isSelected = button.tag == index
            let color = isSelected ? HealthLensTheme.Colors.tealDark : HealthLensTheme.Colors.textSecondary
            var configuration = button.configuration
            configuration?.baseForegroundColor = color
            button.configuration = configuration
            button.tintColor = color
        }
    }
}
