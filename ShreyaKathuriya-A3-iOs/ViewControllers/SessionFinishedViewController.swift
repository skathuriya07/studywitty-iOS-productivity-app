
//
//  SessionFinishedViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 16/05/21.
//

import UIKit

class SessionFinishedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskActionDelegate{

    var session: String! = nil

    weak var databaseController: DatabaseProtocol?
    let hepler = Helpers.sharedInstance
    var isMarked: Bool = false
    var tasks = [Task]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }


    func setupView() {
        databaseController = hepler.getDataBaseController()
        tasks = databaseController!.getFilteredTasks(for: session)

        tableView.register(UINib(nibName: TasksTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: TasksTableViewCell.cellID)

        let feedbackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.rectanglepath"), style: .plain, target: self, action: #selector(onFeedbackButtonDidClick))

        navigationItem.rightBarButtonItem = feedbackButton
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = session

        tableView.delegate = self
        tableView.dataSource = self

        tableView.reloadData()
    }

    @objc func onFeedbackButtonDidClick() {
        // user has to click mark atleast 1 task as complete to move on to the next screen
        if isMarked {
            // if marked, move on to the next screen
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let feedbackController = storyBoard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            feedbackController.session = session
            self.navigationController?.pushViewController(feedbackController, animated: true)
        } else
        // else, dialouge showing that they have to mark at least one task
        {
            hepler.showConfirmationDialog("Info", "Please mark the tasks which are completed to proceed for feedback", displayOnController: self)
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TasksTableViewCell.cellID, for: indexPath) as! TasksTableViewCell
        let task = tasks[indexPath.row]
        cell.delegate = self
        cell.configureUI(task)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func markCompleted(id: String, status: Bool) {
        // updating the status of tasks completed
        databaseController?.updateTaskStatus(id, status)
        isMarked = databaseController!.verifyMarkStatus(session)
    }
}
