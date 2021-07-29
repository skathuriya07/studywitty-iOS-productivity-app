//
//  LaunchViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 05/06/21.
//
// to use lottie: https://www.youtube.com/watch?v=ZtIPsg07bb4


import UIKit
import Lottie

class LaunchViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        setWelcomeMessage()
        self.navigationController?.navigationBar.isHidden = true
    }

    deinit {
        animationView = nil
    }

    private func showAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 2.5
        animationView.play { status in
            if status {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                if let controller = storyBoard.instantiateViewController(withIdentifier: "HomePageTableViewController") as? HomePageTableViewController {
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }

    func setWelcomeMessage() {
        var message: String = ""
        let currentHour = Calendar.current.component(.hour, from: Date())
        let hourInt = Int(currentHour.description)!

        if hourInt >= 7 && hourInt <= 12 {
            message = "Good Morning"
        } else if hourInt >= 12 && hourInt <= 16 {
            message = "Good Afternoon"
        } else if hourInt >= 16 && hourInt <= 20 {
            message = "Good Evening"
        } else {
            message = "Welcome back"
        }

        messageLabel.text = message
    }
}
