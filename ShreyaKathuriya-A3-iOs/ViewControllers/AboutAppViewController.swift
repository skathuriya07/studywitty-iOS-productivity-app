//
//  AboutAppViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 11/06/21.
//

import UIKit

class AboutAppViewController: UIViewController {

    @IBOutlet weak var aboutAppLabel: UILabel!
    @IBOutlet weak var linkLabelOne: UILabel!
    @IBOutlet weak var linkLabelTwo: UILabel!
    @IBOutlet weak var linkLabelThree: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationItem.title = "About the app"
    }

    func setupView() {
        aboutAppLabel.textColor = Helpers.sharedInstance.getThemeColor()
        aboutAppLabel.text = "This application provides assistant to student in the form of timers, take notes while studying, plan the time to be spend on some task, create multiple tasks according to the available time, record voice notes, provide feedback for self analysis, view performance in form of graphs. It also adds feature of getting a thought of the day to keep user motivated."
        linkLabelOne.text = "Lottie animation : " + "https://github.com/airbnb/lottie-ios"
        linkLabelTwo.text = "QuotesAPI : " + "https://quotes.rest/"
        linkLabelThree.text = "GraphView : " + "https://github.com/tmdvs/CoreGraphicsGraph"
    }
}
