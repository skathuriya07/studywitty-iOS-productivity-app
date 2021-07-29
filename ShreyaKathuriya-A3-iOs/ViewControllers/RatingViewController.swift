//
//  RatingViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 19/05/21.
//

import UIKit

class RatingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,FeedbackDelegate{

    @IBOutlet weak var tableView: UITableView!

    var session: String! = nil
    weak var databaseController: DatabaseProtocol?
    let helper = Helpers.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }


    func setupView() {
        databaseController = helper.getDataBaseController()

        let submitButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .done, target: self, action: #selector(onSubmitButtonClick))

        navigationItem.rightBarButtonItem = submitButton
        navigationItem.title = "Self Feedback"

        tableView.register(UINib(nibName: FeedbackTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: FeedbackTableViewCell.cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    @objc func onSubmitButtonClick() {
        self.dismiss(animated: false, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return FeedbackTypes.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTableViewCell.cellID, for: indexPath) as! FeedbackTableViewCell
        cell.delegate = self
        cell.accessibilityIdentifier = FeedbackTypes(rawValue: indexPath.section)?.stringType
        cell.configureUI()
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FeedbackTypes(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func selectedRating(level: FeedbackLevels) {
        databaseController?.saveFeedback(level, session)
    }
}

struct FeedbackLevels {
    var type: String!
    var level: Int32!
}

enum FeedbackTypes: Int, CaseIterable {
    case focusLevel
    case timeManagement
    case overall

    var stringType: String {
        var type: String = ""
        switch self {
        case .focusLevel:
            type = "focusLevel"
        case .timeManagement:
            type = "timeManagement"
        case .overall:
            type = "overall"
        }
        return type
    }

    var title: String {
        var title: String = ""
        switch self {
        case .focusLevel:
            title = "How focused you were?"
        case .timeManagement:
            title = "Time management"
        case .overall:
            title = "Overall experience"
        }
        return title
    }
}
