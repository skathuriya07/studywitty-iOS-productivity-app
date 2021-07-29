//
//  HomePageTableViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 02/05/21.
//


//This is the main Home page of the app
import UIKit
import UserNotifications

class HomePageTableViewController: UITableViewController, UNUserNotificationCenterDelegate, HomePageTableHeaderActionDelegate {
    
    //initializing variable
    weak var databaseController: DatabaseProtocol?
    var author: String? = ""
    var quote = "Loading..."
    var imageURL: String!
    let cellID = "HomePageTableViewCell"
    let helper = Helpers.sharedInstance //all shared functions
    var headerView: HomePageTableHeaderView!    //for quote of the day
    var counter: Int = 0
    weak var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
     func setupView() {
        databaseController = helper.getDataBaseController() //helper file that has common functions

        setupHeaderView() //setting up quote of the day as table header
        getQuoteOfDay() //using API to get quote of the day
        
        //hiding back button that would go to launch screen, but showing the navigation bar
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = helper.getNavBarTitleAttributes()

        // Register delegate to receive notification
        UNUserNotificationCenter.current().delegate = self
        
        // telling to create cell for table view
        tableView.register(UINib(nibName: HomePageTableViewCell.cellID, bundle: nil), forCellReuseIdentifier: HomePageTableViewCell.cellID)
        // to show 'quote of the day is available' notification
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionHandler), userInfo: nil, repeats: true)
    }
    
    // to show 'quote of the day is available' notification  after 5 seconds
    @objc func timerActionHandler() {
        counter += 1
        if counter == 5 {
            helper.displayNotifications(text: "New quote of the day is available", title: "Info", identifier: "quoteID")
            timer.invalidate()
            timer = nil
        }
    }
    
    func getQuoteOfDay() {
        guard let url = URL(string: "https://quotes.rest/qod") else {
            debugPrint("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [unowned self] (data, respons, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(QuoteOfDay.self, from: data)
                    if let quotes = result.contents.quotes.first {
                        self.quote = quotes.quote
                        self.author = quotes.author
                        self.imageURL = quotes.background
                    }
                    self.downloadImage()
                    //
                    DispatchQueue.main.async {
                        self.updateHeaderView()
                        self.tableView.reloadData()
                    }
                } catch {
                    debugPrint(error)
                }
            }
        }
        task.resume()
    }

    func setupHeaderView() {
        // for quote of the day
        // header before table
        headerView = UINib(nibName: "HomePageTableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? HomePageTableHeaderView
        headerView.delegate = self
        headerView.configureUI()    // styling of the view
        tableView.tableHeaderView = headerView  // to save quote on click
    }

    func updateHeaderView() {
        // after getting valued from API
        headerView.authorNameLabel.text = author
        headerView.quoteLabel.text = quote
    }

    func downloadImage() {
        // from API
        guard let url = URL(string: imageURL) else {
            debugPrint("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                debugPrint(error)
            } else if let data = data {
                DispatchQueue.main.async {
                    self.headerView.backgroundImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }

    // Method is responsible for foreground user notifications

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Shows alert view and plays notification sound
        completionHandler([.banner, .sound])
    }
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllFeatures.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.cellID, for: indexPath) as! HomePageTableViewCell
        
        let feature = AllFeatures(rawValue: indexPath.row) //all features from case
        cell.titleLabel.text = feature?.title
        
        //assigning cell to feature
        switch feature {
        case .startSession:
            cell.iconImageView.image = UIImage.init(systemName: "timer")    //for session start
        case .viewNotes:
            cell.iconImageView.image = UIImage.init(systemName: "doc")  //for viewing notes
        case .todo:
            cell.iconImageView.image = UIImage.init(systemName: "pencil")   // for to do today
        case .savedQuotes:
            cell.iconImageView.image = UIImage.init(systemName: "quote.bubble") // for view saved quotes
        case .viewAnalytics:
            cell.iconImageView.image = UIImage.init(systemName: "chart.bar.xaxis")  // for viewing pattern
        case .about:
            cell.iconImageView.image = UIImage.init(systemName: "info") //for about the app page
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feature = AllFeatures(rawValue: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        switch feature {
        case .startSession:
            let viewController = storyboard.instantiateViewController(withIdentifier: "SessionTableViewController") as! SessionTableViewController
            self.navigationController?.pushViewController(viewController, animated: true)

        case .viewNotes:
            let viewController = storyboard.instantiateViewController(withIdentifier: "ShowAllSessionViewController") as! ShowAllSessionViewController
            self.navigationController?.pushViewController(viewController, animated: true)

        case .todo:
            let viewController = storyboard.instantiateViewController(withIdentifier: "TodoViewController") as! TodoViewController
            self.navigationController?.pushViewController(viewController, animated: true)

        case .savedQuotes:
            let viewController = storyboard.instantiateViewController(withIdentifier: "SavedQuoteTableViewController") as! SavedQuoteTableViewController
            self.navigationController?.pushViewController(viewController, animated: true)

        case .viewAnalytics:
            let viewController = storyboard.instantiateViewController(withIdentifier: "ShowPatternViewController") as! ShowPatternViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        case .about:
            let viewController = storyboard.instantiateViewController(withIdentifier: "AboutAppViewController") as! AboutAppViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func onQuoteClicked() {
        // to check if the quote is already saved before
        // if quote is saved, notification says 'quote exists'
        // if not, then notification says 'quote saved'
        if let isPresent = databaseController?.findQuote(for: quote), !isPresent {
            databaseController?.createNewQuotes(quote, author!)
            helper.displayNotifications(text: "Quote saved", title: "Information", identifier: "id")
        } else {
            helper.showConfirmationDialog("Quote Exists", "Quote is already saved!", displayOnController: self)
        }
    }
}

// AllFeatures enum for tableView
enum AllFeatures: Int, CaseIterable {
    case startSession
    case viewNotes
    case todo
    case savedQuotes
    case viewAnalytics
    case about

    var title: String {
        switch self {
        case .startSession:
            return "Start A Session"
        case .viewNotes:
            return "Session Notes"
        case .todo:
            return "To-Do Today"
        case .savedQuotes:
            return "Saved Quotes"
        case .viewAnalytics:
            return "My Pattern"
        case .about:
            return "About the app"
        }
    }
}
