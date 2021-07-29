//
//  ShowAllSessionViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 23/05/21.
//

import UIKit

class ShowAllSessionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!

    //MARK: - Properties

    var allSessionNotes = [SessionNote]()
    var databaseController: DataController!
    let helper = Helpers.sharedInstance
    let cellID = "showSessioncellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        allSessionNotes = getData()
        tableView.reloadData()
    }

    //MARK: - Private methods

    func setupView() {
        databaseController = helper.getDataBaseController()

        navigationItem.title = "All sessions"
        self.navigationController?.navigationBar.titleTextAttributes = helper.getNavBarTitleAttributes()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.showsVerticalScrollIndicator = false
    }

    func getTableViewCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        cell.textLabel?.font = helper.showSessionsTextLabelFont()
        cell.textLabel?.textColor = helper.showSessionsTextLabelColor()
        cell.detailTextLabel?.font = helper.showSessionsDetailTextLabelFont()
        cell.detailTextLabel?.textColor = helper.showSessionsDetailTextLabelColor()
        return cell
    }

    func getData() -> [SessionNote] {
        var sessionNotes = [SessionNote]()
        // fetching data from db
        SessionType.allCases.forEach { sessionType in
            let notes = databaseController.getFilteredNotes(for: sessionType.title)
            sessionNotes.append(SessionNote(session: sessionType, notes: notes))
        }
        return sessionNotes
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSessionNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)

        if cell == nil {
            cell = getTableViewCell()
        }
        // for each session, displaying how many notes for that session are present
        let sessionNote = allSessionNotes[indexPath.row]
        cell?.textLabel?.text = sessionNote.session.title
        cell?.detailTextLabel?.text = "Notes present : \(sessionNote.notes.count)"
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sessionNote = allSessionNotes[indexPath.row]

        if sessionNote.notes.count > 0 {
            // if there is atleast one note present for the sesion, going to next view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let showNotesController = storyboard.instantiateViewController(withIdentifier: "ShowNotesViewController") as! ShowNotesViewController
            showNotesController.allNotes = sessionNote.notes
            showNotesController.session = sessionNote.session.title
            self.navigationController?.pushViewController(showNotesController, animated: true)
        } else
        // if no notes are present for that session, display alertontroller
        {
            helper.showConfirmationDialog("Information", "No notes found", displayOnController: self)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

struct SessionNote {
    var session: SessionType!
    var notes: [Note]!
}
