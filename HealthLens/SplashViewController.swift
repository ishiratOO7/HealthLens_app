//
//  SplashViewController.swift
//  HealthLens
//
//  Created by Rahul Sharma.
//

import UIKit

final class SplashViewController: UIViewController {
    private enum Configuration {
        static let animationName = "HealthLensSplash"
        static let loginStoryboardIdentifier = "LoginViewController"
        static let transitionDuration: TimeInterval = 0.35
        static let fallbackDisplayDuration: TimeInterval = 1.0
    }

    @IBOutlet private weak var heroCardView: UIView!
    @IBOutlet private weak var animationContainerView: UIView!

    private let animationView = LottieAnimationView(name: Configuration.animationName)
    private var didStartAnimation = false
    private var didTransitionToLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HealthLensTheme.Colors.background
        view.tintColor = HealthLensTheme.Colors.gold

        HealthLensTheme.applyHeroCardStyle(to: heroCardView)
        configureAnimationView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimationIfNeeded()
    }

    override var prefersStatusBarHidden: Bool {
        true
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    private func configureAnimationView() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationContainerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: animationContainerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: animationContainerView.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: animationContainerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: animationContainerView.bottomAnchor)
        ])
    }

    private func startAnimationIfNeeded() {
        guard !didStartAnimation else { return }
        didStartAnimation = true

        guard animationView.animation != nil else {
            transitionToLoginInterface(after: Configuration.fallbackDisplayDuration)
            return
        }

        animationView.play { [weak self] _ in
            self?.transitionToLoginInterface()
        }
    }

    private func transitionToLoginInterface(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.transitionToLoginInterface()
        }
    }

    private func transitionToLoginInterface() {
        guard !didTransitionToLogin else { return }
        didTransitionToLogin = true

        guard let loginRoot = healthLens_instantiateStoryboardViewController(
            withIdentifier: Configuration.loginStoryboardIdentifier,
            as: LoginViewController.self
        ) else {
            assertionFailure("LoginViewController scene is missing from Main.storyboard.")
            return
        }

        healthLens_replaceRootViewController(with: loginRoot, duration: Configuration.transitionDuration)
    }
}
