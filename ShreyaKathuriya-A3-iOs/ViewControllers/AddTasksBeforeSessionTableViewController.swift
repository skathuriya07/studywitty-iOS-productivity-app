//
//  AddTasksBeforeSessionTableViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 04/05/21.
//

// This screen use used before starting a session
// the user adds the tasks they aim to complete in the session
import UIKit
import CoreData

class AddTasksBeforeSessionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SessionDelegate {
    
    var time: Int! = 0
    var session: String! = ""

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var startSessionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearTaskButton: UIButton!

    weak var databaseController: DatabaseProtocol?
    let cellID = "AddTasksBeforeSessionTableViewControllerCell"
    var helper = Helpers.sharedInstance
    var isTimerActive: Bool = false
    var sessionController: StartSessionViewController!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initializeSessionController()
    }


    func setupView() {
        databaseController = helper.getDataBaseController()
        // to get tasks baseed on the session type
        tasks = databaseController!.getFilteredTasks(for: session)

        updateErrorLabel()

        navigationItem.title = "Add tasks"
        
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false //to hide the lines of cell separator if no task is present

        clearTaskButton.addBorder(side: .right, color: .black, width: 1)

        let addTaskButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))

        navigationItem.rightBarButtonItem = addTaskButton

        tableView.reloadData()
    }

    func updateErrorLabel() {
        if tasks.count > 0 {
            // if there is atleast 1 task  present, the label saying 'No task present' is hidden
            errorLabel.isHidden = true
        } else {
            // if there is no task present, the lable saying 'No task present' is shown
            errorLabel.isHidden = false
        }
    }

    func initializeSessionController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sessionController = storyboard.instantiateViewController(withIdentifier: "StartSessionViewController") as? StartSessionViewController
        sessionController.delegate = self
    }

    @objc func addButtonPressed(_ sender: UIButton) {
        //to add a task
        let alert = UIAlertController(title: "Add Task", message: "Please enter a task you would like to work on in the session.", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Task", style: .default) { [self] (action) in
            if let text = textField.text, text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 { //whitespace reference: //https://stackoverflow.com/questions/41435894/countelements-in-swift-3
                // checking if string input os empty or contains a string
                databaseController?.createTask(text, session, false)
                tasks = databaseController!.getFilteredTasks(for: session)
                updateErrorLabel()
                tableView.reloadData()
            } else {
                helper.showConfirmationDialog("No text Enteres", "Invalid text entered", displayOnController: self)
            }
        }
        alert.addAction(action)
        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add a new Task"
        }
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }

    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    func getTableViewCell() -> UITableViewCell {
        // getting and styling the cell
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        cell.textLabel?.font = helper.saveNotesTextLabelFont()
        cell.detailTextLabel?.font = helper.saveNotesDetailTextLabelFont()
        cell.textLabel?.textColor = helper.saveNotesTextLabelColor()
        cell.detailTextLabel?.textColor = helper.saveNotesDetailTextLabelColor()
        return cell
    }

    @IBAction func onClearTaskButtonClick(_ sender: UIButton) {
        // to clear all present tasks
        if tasks.count > 0 {
            for task in tasks {
                databaseController?.deleteTask(for: task.taskId!)
            }
            tasks.removeAll()
            tableView.reloadData()
            updateErrorLabel()
        } else {
            helper.showConfirmationDialog("Info", "No tasks to clear", displayOnController: self)
        }
    }

    @IBAction func onStartSessionButtonDidClick(_ sender: Any) {
        if tasks.count > 0 {
            // if there is atleast 1 task present, start the session
            sessionController.session = session
            sessionController.isTimerActive = isTimerActive
            if !isTimerActive {
                sessionController.time = time
            }
            self.navigationController?.pushViewController(sessionController, animated: true)
        } else {
            // there has to be atleast one task to start a session
            helper.showConfirmationDialog("No tasks present", "To begin the session add some tasks", displayOnController: self)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)

        if cell == nil {
            cell = getTableViewCell()
        }

        let task = tasks[indexPath.row]
        cell?.textLabel?.text = task.task
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            databaseController?.deleteTask(for: tasks[indexPath.row].taskId!)
            tasks = databaseController!.getFilteredTasks(for: session)
            updateErrorLabel()
            tableView.reloadData()
        }
    }

    func activeTimer(value: String) {} // conforming to Session delegat protocol

    func timerRunning(status: Bool) {
        // if a session is running, user can view/delete/add tasks and go back to the active session
        // if a session is not actie, they can add tasks
        isTimerActive = status
        if status {
            startSessionButton.setTitle("View active session", for: .normal)
        } else {
            startSessionButton.setTitle("Start the session", for: .normal)
        }
    }
}
