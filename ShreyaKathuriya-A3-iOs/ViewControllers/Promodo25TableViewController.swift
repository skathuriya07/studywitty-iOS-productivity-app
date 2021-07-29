//
//  Promodo25TableViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 03/05/21.
//

import UIKit

class Promodo25TableViewController: UITableViewController {

    let DETAIL_SECTION = 0
    let TASK_SECTION = 1
    let WORK_SECTION = 2
    let COFFEE_SECTION = 3
    let REPEAT_SECTION = 4

    let DETAIL_CELL = "detailCell"
    let TASK_CELL = "taskCell"
    let WORK_CELL = "workCell"
    let COFFEE_CELL = "coffeeCell"
    let REPEAT_CELL = "repeatCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == DETAIL_SECTION {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: DETAIL_CELL, for: indexPath)
            detailCell.textLabel?.text = "Promodoro 25/5 is a productivity technique."
            detailCell.textLabel!.text! += "\n"
            detailCell.textLabel!.text! += "It suggests to focusly work in chunks of time and take a break."
            detailCell.textLabel!.text! += "\n"
            detailCell.textLabel!.text! += "In 25/5, you work for 25 mins without distractions."
            detailCell.textLabel!.text! += "\n"
            detailCell.textLabel!.text! += "Then, take a 5 mins break."
            detailCell.textLabel!.text! += "\n"
            detailCell.textLabel!.text! += "Repeat this for 4 session at max before taking a long break."
            detailCell.textLabel?.numberOfLines = 0
            return detailCell
        }
        else if indexPath.section == TASK_SECTION {
            let taskCell = tableView.dequeueReusableCell(withIdentifier: TASK_CELL, for: indexPath)
            taskCell.textLabel?.text = "Write down your tasks"
            taskCell.textLabel?.numberOfLines = 0
            taskCell.imageView?.sizeToFit()
            return taskCell

        }
        else if indexPath.section == WORK_SECTION {
            let workCell = tableView.dequeueReusableCell(withIdentifier: WORK_CELL, for: indexPath)
            workCell.textLabel?.text = "Work on (a portion) of it for 25 mins"
            workCell.textLabel?.numberOfLines = 0
            return workCell
        }
        else if indexPath.section == COFFEE_SECTION {
            let breakCell = tableView.dequeueReusableCell(withIdentifier: COFFEE_CELL, for: indexPath)
            breakCell.textLabel?.text = "Take a 5 mins break"
            breakCell.textLabel?.numberOfLines = 0
            return breakCell
        }
        else if indexPath.section == REPEAT_SECTION {
            let repeatCell = tableView.dequeueReusableCell(withIdentifier: REPEAT_CELL, for: indexPath)
            repeatCell.textLabel?.text = "Repeat this for at max 4 times before taking a longer break"
            repeatCell.textLabel?.numberOfLines = 0
            return repeatCell
        }
        let breakCell = tableView.dequeueReusableCell(withIdentifier: REPEAT_CELL, for: indexPath)
        return breakCell
    }
}
