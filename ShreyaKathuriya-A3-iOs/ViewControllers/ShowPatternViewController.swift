//
//  ShowPatternViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 08/06/21.
//

import UIKit

class ShowPatternViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    //MARK: - Properties

    weak var databaseController: DatabaseProtocol?
    private let helper = Helpers.sharedInstance
    private var feedbackData = [FeedbackData]()
    private var graphFocusLevelData = [[String : Int]]()
    private var graphTimeManagementData = [[String : Int]]()
    private var graphOverallExpData = [[String : Int]]()

    var graph: GraphView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //MARK: - Private methods

    private func setupView() {
        navigationItem.title = "My pattern"

        databaseController = helper.getDataBaseController()

        updateGraphData()
        graphFocusLevelData = getFocusLevelData()
        graphTimeManagementData = getTimeManagementData()
        graphOverallExpData = getOverallExpData()

        tableView.register(UINib(nibName: GraphTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: GraphTableViewCell.cellID)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.reloadData()
    }

    private func updateGraphData() {
        // getting data for all sessions (looping)
        for type in SessionType.allCases{
            let data = databaseController!.getFilteredFeedback(type.title)
            //initiating variables
            var allFocusLevelFeedback = [Int32]()
            var allTimeManagementFeedback = [Int32]()
            var alloverallFeedback = [Int32]()
            
            //array of feedback entities that of focus level in type
            let focusLevelData = data.filter{
                $0.type == FeedbackTypes.focusLevel.stringType
            }

            //array of feedback entities of time management type
            let timeManagementData = data.filter{
                $0.type == FeedbackTypes.timeManagement.stringType
            }
            
            //array of feedback entities of experience type
            let overallData = data.filter{
                $0.type == FeedbackTypes.overall.stringType
            }
            
            //collecting all the focus level data into the array
            for flData in focusLevelData {
                allFocusLevelFeedback.append(flData.feedbackLevel)
            }
            //collecting all the time management data into the array
            for tmData in timeManagementData {
                allTimeManagementFeedback.append(tmData.feedbackLevel)
            }
            //collecting all experience data into the array
            for orData in overallData {
                alloverallFeedback.append(orData.feedbackLevel)
            }
            
            //appenind values that will be used for the graph for each session
            feedbackData.append(FeedbackData(session: type.graphTitle, focusLevelData: getAverage(allFocusLevelFeedback), timeManagementData: getAverage(allTimeManagementFeedback), overallData: getAverage(alloverallFeedback)))
        }
    }

    func getAverage(_ data: [Int32]) -> Double {
        data.reduce(0.0) {
            $0 + Double($1)/Double(data.count)
        }
    }

    func getFocusLevelData() -> [[String : Int]] {
        // focus level data in all sessions
        for type in SessionType.allCases {
            let data = feedbackData.filter{
                $0.session == type.graphTitle
            }.first
            if let data = data {
                graphFocusLevelData.append([data.session : Int(data.focusLevelData * 20)]) //*20 for graph
            } else {
                graphFocusLevelData.append([type.graphTitle : 0])
            }
        }
        return graphFocusLevelData
    }

    func getTimeManagementData() -> [[String : Int]] {
        // time managememnt data in all sessions
        for type in SessionType.allCases {
            let data = feedbackData.filter{
                $0.session == type.graphTitle
            }.first
            if let data = data {
                graphTimeManagementData.append([data.session : Int(data.timeManagementData * 20)])
            } else {
                graphTimeManagementData.append([type.graphTitle : 0])
            }
        }
        return graphTimeManagementData
    }

    func getOverallExpData() -> [[String : Int]] {
        // experiencel data in all sessions
        for type in SessionType.allCases {
            let data = feedbackData.filter{
                $0.session == type.graphTitle
            }.first
            if let data = data {
                graphOverallExpData.append([data.session : Int(data.overallData * 20)])
            } else {
                graphOverallExpData.append([type.graphTitle : 0])
            }
        }
        return graphOverallExpData
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return FeedbackTypes.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GraphTableViewCell.cellID, for: indexPath) as! GraphTableViewCell
        let graphFrame = CGRect(x: -10, y: 0, width: cell.frame.width - 30, height: cell.frame.height - 40)
        if FeedbackTypes(rawValue: indexPath.section) == .focusLevel {
            graph = GraphView(frame: graphFrame, data: graphFocusLevelData)
        } else if FeedbackTypes(rawValue: indexPath.section) == .timeManagement {
            graph = GraphView(frame: graphFrame, data: graphTimeManagementData)
        } else {
            graph = GraphView(frame: graphFrame, data: graphOverallExpData)
        }
        cell.graphView.addSubview(graph)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FeedbackTypes(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

struct FeedbackData {
    var session: String
    var focusLevelData: Double!
    var timeManagementData: Double!
    var overallData: Double!
}
