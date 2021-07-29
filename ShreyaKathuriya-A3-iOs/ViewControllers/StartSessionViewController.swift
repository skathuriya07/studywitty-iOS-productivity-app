//
//  StartSessionViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 06/05/21.
//
// For floating button, https://guides.codepath.com/ios/Adding-Views-to-the-Window
// and
// https://stackoverflow.com/questions/48298984/insert-a-floating-action-button-on-uitableview-in-swifthas
//been used for reference

// This is the session screen when a asession is on

import AVFoundation
import Foundation
import UIKit

protocol SessionDelegate {
    func activeTimer(value: String)
    func timerRunning(status: Bool)
}

class StartSessionViewController: UIViewController {

    //MARK: - Properties
    var session: String!
    var time: Int!
    var isTimerActive: Bool = false
    var delegate: SessionDelegate!

    weak var databaseController: DatabaseProtocol?
    let helper = Helpers.sharedInstance
    var alarmPlayer: AVPlayer!
    var repeatCount: Int = 0
    weak var sessionTimer: Timer?
    weak var repeatTimer: Timer?
    var repeatCyclesRequired: Int = 0
    var waitTime: Int = 0
    var sessionTime: Int = 0
    var floatingButton = UIButton(type: .custom)

    //MARK: - Outlets

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var addNoteTextField: UITextField!
    @IBOutlet weak var saveNoteButton: UIButton!
    @IBOutlet weak var addNoteTextFieldHeightCst: NSLayoutConstraint!
    @IBOutlet weak var saveNoteButtonHeightCst: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isTimerActive {
            updateRepeatCyclesRequired()
            startAllTimers()
        }
    }

    func setupView() {
        
        // Setting up UI and styling buttons and labels
        databaseController = helper.getDataBaseController()

        playButton.isHidden = true
        playButton.isEnabled = false

        timeLabel.layer.borderWidth = 2
        timeLabel.layer.cornerRadius = 10
        timeLabel.layer.borderColor = UIColor.systemGray6.cgColor

        addNoteTextField.placeholder = "Type here..."

        saveNoteButton.layer.borderWidth = 1
        saveNoteButton.layer.borderColor = UIColor.systemGray6.cgColor
        saveNoteButton.layer.cornerRadius = 8
        saveNoteButton.layer.masksToBounds = true
        saveNoteButton.tintColor = .black

        stopButton.addBorder(side: .right, color: .black, width: 1)
        addNoteButton.addBorder(side: .left, color: .black, width: 1)

        navigationItem.title = session
        
        //floating button for displaying time on other screens also
        setFloatingButton()
        setFloatingButtonTitle(timeLabel.text!)
        showFloatingButton()
        //add note  is not visible until the add note button is clicked
        hideNoteView()
    }

    func playAlarm() {
        let url = Bundle.main.url(forResource: "alarmTune", withExtension: "mp3")
        alarmPlayer = AVPlayer.init(url: url!)
        alarmPlayer.play()
    }

    func stopAlarm() {
        alarmPlayer.pause()
    }

    func setFloatingButton() {
        let width: CGFloat = 130
        floatingButton.frame = CGRect(x: self.view.frame.midX - width/2, y: self.view.frame.maxY - 100, width: width, height: 50) //positioning
        floatingButton.backgroundColor = helper.getThemeColor()
        floatingButton.clipsToBounds = true
        floatingButton.layer.cornerRadius = 25
        floatingButton.isUserInteractionEnabled = false
        // assiging the button as subview for all screens in the window
        if let window = UIApplication.shared.windows.first { //root
            window.addSubview(floatingButton)
        }
    }

    func setFloatingButtonTitle(_ title: String) {
        floatingButton.setTitle(title, for: .normal)
    }

    func showFloatingButton() {
        floatingButton.isHidden = false
    }

    func hideFloatingButton() {
        floatingButton.isHidden = true
    }

    //MARK: - Timer implementation

    @objc func handleRepeat() {
        // repeaating for promodoro
        repeatCount += 1
        helper.displayNotifications(text: "Repeat cycle \(repeatCount), left cycles \(repeatCyclesRequired - repeatCount)", title: "Information", identifier: "timer")
        if time == 0 {
            sessionTimer?.invalidate()
            sessionTimer = nil
            time = sessionTime
            sessionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }

        if repeatCount == repeatCyclesRequired {
            stopAllTimers()
            delegate.timerRunning(status: false)
            hideFloatingButton()
            moveToSessionFinishScreen()
        }
    }

    @objc func timerAction() {
        // converting into seconds
        let hours  = Int(time/3600)
        var leftOverTime = Int(time - hours*60*60)
        let minutes = Int(leftOverTime/60)
        leftOverTime = Int(leftOverTime - (minutes*60))

        timeLabel.text = "\(hours) : \(minutes) : \(leftOverTime)"
        delegate.activeTimer(value: "\(hours) : \(minutes) : \(leftOverTime)")
        setFloatingButtonTitle("\(hours) : \(minutes) : \(leftOverTime)")
        if time == 0 {
            playAlarm()
            sessionTimer?.invalidate()
            updateTime()
        } else {
            time -= 1
        }
    }

    func updateTime() {
        //if it is a promodoro session, timer will play again until the cycles are complete
        // or user ends the sessoin
        if (session == SessionType.promodoro25.title) || (session == SessionType.promodoro50.title) {
            time = waitTime
            playAlarm()
            helper.displayNotifications(text: "It's break time, relax ...", title: "Break!", identifier: "breakTime")
            sessionTimer?.invalidate()
            sessionTimer = nil
            sessionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        } else
        // if at the end of the timer, and it is not promodoro, it will not repeate and end
        {
            moveToSessionFinishScreen()
            hideFloatingButton()
        }
    }

    func updateRepeatCyclesRequired() {
        // promodoro runs for 4 cycles
        if session == SessionType.promodoro25.title {
            repeatCyclesRequired = 4
            sessionTime = 5 // 5 for demonstration purpose, else 1500
            waitTime = 2 //2 for demonstration purpoe, else 300
        } else if session == SessionType.promodoro50.title {
            repeatCyclesRequired = 2
            sessionTime = 3000
            waitTime = 600
        }
    }

    func stopAllTimers() {
        if repeatTimer != nil {
            repeatTimer?.invalidate()
            repeatTimer = nil
        }

        if sessionTimer != nil {
            sessionTimer?.invalidate()
            sessionTimer = nil
        }
    }

    func startAllTimers() {
        if sessionTimer == nil {
            sessionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            // promodoro
            if (session == SessionType.promodoro25.title) || (session == SessionType.promodoro25.title) && repeatTimer == nil {
                repeatTimer = Timer.scheduledTimer(timeInterval: TimeInterval(sessionTime+waitTime+2), target: self, selector: #selector(handleRepeat), userInfo: nil, repeats: true)
            }
        }
        delegate.timerRunning(status: true)
    }

    //MARK: - Add note implementation

    func showAddNoteView() {
        // this is visible only when user clicks on add note first time and then it stays there
        addNoteTextFieldHeightCst.constant = 60
        saveNoteButtonHeightCst.constant = 40
        animateView()
        addNoteTextField.becomeFirstResponder()
    }

    func hideNoteView() {
        addNoteTextFieldHeightCst.constant = 0
        saveNoteButtonHeightCst.constant = 0
    }

    func animateView() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded() //to animate
        }
    }

    func moveToSessionFinishScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SessionFinishedViewController") as! SessionFinishedViewController
        viewController.session = session
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true) {
            let controller = self.navigationController?.viewControllers[1] as! HomePageTableViewController
            self.navigationController?.popToViewController(controller, animated: false)
        }
    }

    func addNote() {
        showAddNoteView()
    }

    func recordNotePermission() {
        //permission: https://stackoverflow.com/questions/24318791/avaudiosession-swift
        AVAudioSession.sharedInstance().requestRecordPermission { [unowned self] isGranted in
            if isGranted {
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    guard let recordNoteController = storyBoard.instantiateViewController(withIdentifier: "RecordNoteViewController") as? RecordNoteViewController else { return }
                    recordNoteController.fromRecordNote = true  //recording
                    recordNoteController.session = session
                    recordNoteController.modalPresentationStyle = .overCurrentContext   //way of presenting
                    present(recordNoteController, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    helper.showConfirmationDialog("Info", "Permission denied, please grant permission to record audio from app settings", displayOnController: self)
                }
            }
        }
    }

    //MARK: - Action handlers

    @IBAction func stopButtonPressed(_ sender: Any) {
        time = 0
        timeLabel.text = "Session end"

        stopAllTimers()
        hideFloatingButton()
        moveToSessionFinishScreen()
        delegate.timerRunning(status: false)
        delegate.activeTimer(value: "")

        playButton.isHidden = false
        pauseButton.isHidden = true
        playButton.isEnabled = false
        pauseButton.isEnabled = false
    }

    @IBAction func playButtonPressed(_ sender: Any) {
        playButton.isHidden = true
        pauseButton.isHidden = false
        playButton.isEnabled = false
        pauseButton.isEnabled = true
        startAllTimers()
    }

    @IBAction func pauseButtonPressed(_ sender: Any) {
        stopAllTimers()
        playButton.isHidden = false
        pauseButton.isHidden = true
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }

    @IBAction func onAddNoteDidClick(_ sender: UIButton) {
        //https://www.hackingwithswift.com/read/4/3/choosing-a-website-uialertcontroller-action-sheets
        // for UI Alert action sheet
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addNoteAction = UIAlertAction(title: "Add note", style: .default) { [unowned self] action in
            self.addNote()
        }
        //record  note button permission
        let recordNoteAction = UIAlertAction(title: "Record note", style: .default) { [unowned self] action in
            self.recordNotePermission()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addNoteAction)
        alertController.addAction(recordNoteAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .black
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func saveNoteButtonDidClick(_ sender: Any) {
        let title = "Info"
        if let enteredNote = addNoteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), enteredNote.count > 0 {
            databaseController?.createANote(enteredNote, Date(), false, session, nil)
        } else {
            helper.showConfirmationDialog(title, "Invalid text, saving failed", displayOnController: self)
        }
        addNoteTextField.resignFirstResponder()
        addNoteTextField.text = nil
    }
}
