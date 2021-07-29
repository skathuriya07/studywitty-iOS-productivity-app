//
//  TodoViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 25/05/21.
//

import UIKit
import UserNotifications

class TodoViewController: UIViewController, UNUserNotificationCenterDelegate, TodoAction {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveTodoButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Properties

    var databaseController: DataController!
    let helper = Helpers.sharedInstance
    let cellID = "showTodoCellIdentifier"
    var todaysTodo = [Todo]()
    var yesterdaysTodo = [Todo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        databaseController = helper.getDataBaseController()
        navigationItem.title = "Todo list"
        self.navigationController?.navigationBar.titleTextAttributes = helper.getNavBarTitleAttributes()

        UNUserNotificationCenter.current().delegate = self


        textField.placeholder = "Type here..."

        saveTodoButton.layer.borderWidth = 1
        saveTodoButton.layer.borderColor = UIColor.systemGray6.cgColor
        saveTodoButton.layer.cornerRadius = 10
        saveTodoButton.layer.masksToBounds = true
        saveTodoButton.tintColor = .black

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.showsVerticalScrollIndicator = false

        tableView.register(UINib(nibName: TodoTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: TodoTableViewCell.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        refreshUI()
    }

    func refreshUI() {
        //one day old notes
        let allTodos = databaseController.getAllTodos()
        let yesterdayDate = helper.getDateString(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        // filtering to dos based on yesterday and today
        todaysTodo = allTodos.filter {
            $0.createdAt == helper.getDateString(from: Date()) //(like for loop) element in the all todo array
        }
        yesterdaysTodo = allTodos.filter {
            $0.createdAt == yesterdayDate
        }
        tableView.reloadData()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Shows alert view and plays notification sound
        completionHandler([.banner, .sound])
    }

    @IBAction func onSaveButtonClick(_ sender: UIButton) {
        textField.resignFirstResponder()
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.count > 0 {
            databaseController.createATodo(text)
            refreshUI()
        }
        textField.text = nil
    }
}

extension TodoViewController: UITableViewDelegate {}

extension TodoViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        TodoDateType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TodoDateType(rawValue: section) == .today {
            return todaysTodo.count
        } else {
            return yesterdaysTodo.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.cellID, for: indexPath) as! TodoTableViewCell

        if TodoDateType(rawValue: indexPath.section) == .today {
            let todo = todaysTodo[indexPath.row]
            cell.configureUI(todo)
        } else {
            let todo = yesterdaysTodo[indexPath.row]
            cell.configureUI(todo)
        }

        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width, height: 30))
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.text = TodoDateType(rawValue: section)?.title
        view.addSubview(label)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (TodoDateType(rawValue: section) == .today && todaysTodo.count > 0) || (TodoDateType(rawValue: section) == .yesterday && yesterdaysTodo.count > 0) {
            return 30
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if TodoDateType(rawValue: indexPath.section) == .today {
                guard let id = todaysTodo[indexPath.row].id else { return }
                databaseController.deleteTodo(for: id)
                todaysTodo.remove(at: indexPath.row)
            } else {
                guard let id = yesterdaysTodo[indexPath.row].id else { return }
                databaseController.deleteTodo(for: id)
                yesterdaysTodo.remove(at: indexPath.row)
            }
            helper.displayNotifications(text: "Todo removed", title: "Information", identifier: "todo")
            tableView.reloadData()
        }
    }

    func markCompleted(id: String, status: Bool) {
        databaseController.updateTodoStatus(id, status)
    }
}

enum TodoDateType: Int, CaseIterable {
    case yesterday
    case today

    var title: String {
        switch self {
        case .yesterday:
            return "Yesterday's todo"
        case .today:
            return "Today's todo"
        }
    }
}
