//
//  SceneDelegate.swift
//  HealthLens
//
//  Created by Rahul Sharma on 27/04/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // ─── Option A (current): storyboard-driven flow ───────────────────────
        // The storyboard's initialViewController is SplashViewController, which
        // handles auth and then calls healthLens_showMainDashboard() to present
        // CustomTabBarController. No extra setup needed here.
        window?.overrideUserInterfaceStyle = .light
        window?.tintColor                  = HealthLensTheme.Colors.gold
        window?.backgroundColor            = HealthLensTheme.Colors.background

        // ─── Option B: programmatic root (use when user is already authenticated) ─
        // Uncomment the block below and remove the storyboard's "Main Interface"
        // entry from the target's Info.plist (or set it to an empty string).
        //
        // let window = UIWindow(windowScene: windowScene)
        // window.overrideUserInterfaceStyle = .light
        // window.tintColor       = HealthLensTheme.Colors.gold
        // window.backgroundColor = HealthLensTheme.Colors.background
        // window.rootViewController = CustomTabBarController()
        // window.makeKeyAndVisible()
        // self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
