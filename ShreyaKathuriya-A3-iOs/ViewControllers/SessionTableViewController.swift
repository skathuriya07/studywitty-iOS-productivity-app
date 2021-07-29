//
//  SessionTableViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 02/05/21.
//

// This is the table view that shows all Sessions the user can choose from

import UIKit

class SessionTableViewController: UITableViewController,SessionsTableViewDelegate {

    let helper = Helpers.sharedInstance //shared functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        // session view cell
        tableView.register(UINib(nibName: SessionsTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: SessionsTableViewCell.cellID)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SessionType.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionsTableViewCell.cellID, for: indexPath) as! SessionsTableViewCell
        cell.delegate = self

        let sessionType = SessionType(rawValue: indexPath.row)
        cell.titleLabel.text = sessionType?.title
        cell.session = sessionType?.title

        switch sessionType {
        case .promodoro25:
            cell.iconImageView.image = UIImage(systemName: "timelapse")
        case .promodoro50:
            cell.iconImageView.image = UIImage(systemName: "timelapse")
        case .session30:
            cell.iconImageView.image = UIImage(systemName: "timer")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryButton.isHidden = true
        case .session45:
            cell.iconImageView.image = UIImage(systemName: "timer")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryButton.isHidden = true
        case .session60:
            cell.iconImageView.image = UIImage(systemName: "timer")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryButton.isHidden = true
        case .session120:
            cell.iconImageView.image = UIImage(systemName: "timer")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryButton.isHidden = true
        case .customSession:
            cell.iconImageView.image = UIImage(systemName: "square.and.pencil")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryButton.isHidden = true
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sessionType = SessionType(rawValue: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if sessionType != .customSession {
            let controller = storyboard.instantiateViewController(withIdentifier: "AddTasksBeforeSessionTableViewController") as? AddTasksBeforeSessionTableViewController
            controller?.session = sessionType?.title
            controller?.time = sessionType?.time
            self.navigationController?.pushViewController(controller!, animated: true)
        } else {
            let controller = storyboard.instantiateViewController(withIdentifier: "SetCustomTimeViewController") as! SetCustomTimeViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func onAccessoryClick(_ session: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if session == SessionType.promodoro25.title {
            let controller = storyboard.instantiateViewController(withIdentifier: "Promodo25TableViewController") as! Promodo25TableViewController
            present(controller, animated: true, completion: nil)
        } else {
            let controller = storyboard.instantiateViewController(withIdentifier: "Promodo50TableViewController") as! Promodo50TableViewController
            present(controller, animated: true, completion: nil)
        }
    }
}
