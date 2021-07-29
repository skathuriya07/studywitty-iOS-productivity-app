//
//  QuotesTableViewController.swift
//  SHREYAKATHURIYA-A02
//
//  Created by Shreya Kathuriya on 21/04/21.
//

import UIKit
import UserNotifications

class SavedQuoteTableViewController: UITableViewController, UNUserNotificationCenterDelegate{

    weak var databaseController: DatabaseProtocol?
    var savedQuotes = [Quotes]()
    var errorLabel: UILabel!
    let CELL_QUOTE = "savedQuoteCell"
    let helper = Helpers.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

   func setupView() {
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableView.automaticDimension

        databaseController = helper.getDataBaseController()

        errorLabel = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height / 2 - 100, width: UIScreen.main.bounds.width, height: 50))
        errorLabel.text = "No quotes present"
        errorLabel.font = .systemFont(ofSize: 25)
        errorLabel.textAlignment = .center

        // Register delegate to receive notification
        UNUserNotificationCenter.current().delegate = self

        savedQuotes = databaseController?.fetchAllSavedQuotes() ?? []
        tableView.reloadData()
        showErrorLabel()
    }

    func showErrorLabel() {
        if savedQuotes.count > 0 {
            errorLabel.removeFromSuperview()
        } else {
            self.view.addSubview(errorLabel)
        }
    }

    // Method is responsible for foreground user notifications

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Shows alert view and plays notification sound
        completionHandler([.banner, .sound])
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedQuotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quoteCell = tableView.dequeueReusableCell(withIdentifier: CELL_QUOTE, for: indexPath)
        quoteCell.textLabel?.numberOfLines = 0

        let quote = savedQuotes[indexPath.row]
        quoteCell.textLabel?.text =  "\"" + quote.quote! + "\""
        quoteCell.detailTextLabel?.text = "- " + quote.author!
        return quoteCell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = savedQuotes[indexPath.row].quoteId else { return }
            databaseController!.deleteQuote(for: id)
            savedQuotes.remove(at: indexPath.row)
            showErrorLabel()
            tableView.reloadData()
        }
    }
}
