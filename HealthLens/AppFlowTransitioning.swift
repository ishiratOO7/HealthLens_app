//
//  AppFlowTransitioning.swift
//  HealthLens
//
//  Created by Codex.
//

import UIKit

extension UIViewController {
    func healthLens_instantiateStoryboardViewController<T: UIViewController>(
        withIdentifier identifier: String,
        as type: T.Type = T.self
    ) -> T? {
        storyboard?.instantiateViewController(withIdentifier: identifier) as? T
    }

    func healthLens_replaceRootViewController(
        with newRootViewController: UIViewController,
        duration: TimeInterval = 0.35
    ) {
        guard let window = view.window else {
            return
        }

        UIView.transition(
            with: window,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = newRootViewController
            },
            completion: nil
        )
    }

    func healthLens_presentFullScreen(_ viewController: UIViewController, animated: Bool = true) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated)
    }
}
