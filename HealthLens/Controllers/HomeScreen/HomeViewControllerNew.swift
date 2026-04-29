//
//  ViewController.swift
//  HealthLens
//
//  Created by Rahul Sharma on 27/04/26.
//

import UIKit

final class HomeViewControllerNew: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
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
        greetingLabel.text = greetingMessage(name: "Rahul")
    }
    
    private func greetingMessage(name: String ) -> String {
        return """
        \(Constent.getWishMessage()), \(name) 👋
        A focused dashboard for your health.
        """
    }
    
}
