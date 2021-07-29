//
//  SetCustomTimeViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 20/05/21.
//

import UIKit

class SetCustomTimeViewController: UIViewController {

    var sendMins: Int = 0

    @IBOutlet weak var hoursInput: UITextField!
    @IBOutlet weak var minutesInput: UITextField!
    @IBOutlet weak var doneButton: UIButton!

    let helper = Helpers.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor.systemGray6.cgColor
        doneButton.layer.cornerRadius = 8
        doneButton.layer.masksToBounds = true

        hoursInput.keyboardType = .numberPad
        minutesInput.keyboardType = .numberPad
    }

    @IBAction func donePressed(_ sender: Any) {
        let hour: Int = Int(hoursInput.text ?? "") ?? 0
        let min: Int = Int(minutesInput.text ?? "") ?? 0

        if ((hour > 5) || (hour < 0)) {
            // limiting hour intup to bei between 0 and 5
            helper.showConfirmationDialog("Invalid input", "Please input hour between 0 to 5 hours", displayOnController: self)
        }
        if ((min > 60) || (min < 0)){
            // making susre right info for minuite is inputed
            helper.showConfirmationDialog("Invalid input", "Please input minute between 0 to 59", displayOnController: self)
        }

        sendMins = ((60*hour) + min)*60

        if sendMins != 0 {
            // next view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AddTasksBeforeSessionTableViewController") as! AddTasksBeforeSessionTableViewController
            controller.session = "Custom Timed Session"
            controller.time = sendMins
            self.navigationController?.pushViewController(controller, animated: true)
        } else
        //notifying user about wrong input
        {
            helper.showConfirmationDialog("Info", "Invalid time entered", displayOnController: self)
        }
    }
}
