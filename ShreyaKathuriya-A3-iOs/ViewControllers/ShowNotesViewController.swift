//
//  ShowNotesViewController.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 23/05/21.
//

import UIKit
import UserNotifications

class ShowNotesViewController: UIViewController, UNUserNotificationCenterDelegate,UITableViewDelegate,UITableViewDataSource {

    //MARK: - Outlets

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Properties

    var session: String!
    var allNotes: [Note]!

    var databaseController: DataController!
    let helper = Helpers.sharedInstance
    let cellID = "showNotecellIdentifier"
    var audioNotes = [Note]()
    var textNotes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        databaseController = helper.getDataBaseController()
        updateData()

        navigationItem.title = session
        self.navigationController?.navigationBar.titleTextAttributes = helper.getNavBarTitleAttributes()

        errorLabel.text = "No notes present"
        showErrorLabel()

        UNUserNotificationCenter.current().delegate = self

        tableView.delegate = self
        tableView.dataSource = self

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.showsVerticalScrollIndicator = false
    }

    func getTableViewCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        cell.textLabel?.font = helper.saveNotesTextLabelFont()
        cell.detailTextLabel?.font = helper.saveNotesDetailTextLabelFont()
        cell.textLabel?.textColor = helper.saveNotesTextLabelColor()
        cell.detailTextLabel?.textColor = helper.saveNotesDetailTextLabelColor()
        return cell
    }

    func getAudioIcon() -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(systemName: "music.quarternote.3")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemPink
        return imageView
    }

    func updateData() {
        //looping over notes
        // reference from:https://medium.com/swlh/filtering-in-swift-8524bbd55119
        //filtering out to get the non empty string name
        audioNotes = allNotes.filter{
            $0.audioNoteUrl?.trimmingCharacters(in: .whitespacesAndNewlines).count != nil
        }

        textNotes = allNotes.filter{
            $0.audioNoteUrl?.trimmingCharacters(in: .whitespacesAndNewlines).count == nil
        }
    }

    func showErrorLabel() {
        if allNotes.count > 0 {
            errorLabel.isHidden = true
        } else {
            errorLabel.isHidden = false
        }
    }

    // Method is responsible for foreground user notifications

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Shows alert view and plays notification sound
        completionHandler([.banner, .sound])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        NoteType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NoteType(rawValue: section) == .audio {
            return audioNotes.count
        } else {
            return textNotes.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)

        if cell == nil {
            cell = getTableViewCell()
        }

        if NoteType(rawValue: indexPath.section) == .audio {
            let audioNote = audioNotes[indexPath.row]
            cell?.textLabel?.text = audioNote.title
            cell?.detailTextLabel?.text = helper.getDateString(from: audioNote.createdAt!)
            cell?.accessoryView = getAudioIcon()
        } else {
            let textNote = textNotes[indexPath.row]
            cell?.textLabel?.text = textNote.title
            cell?.detailTextLabel?.text = helper.getDateString(from: textNote.createdAt!)
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if NoteType(rawValue: indexPath.section) == .audio {
            let audioNote = audioNotes[indexPath.row]
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let recordNoteController = storyBoard.instantiateViewController(withIdentifier: "RecordNoteViewController") as? RecordNoteViewController else { return }
            recordNoteController.fromRecordNote = false
            recordNoteController.session = session
            recordNoteController.audioFileName = audioNote.audioNoteUrl
            recordNoteController.modalPresentationStyle = .overCurrentContext //to view audio note
            present(recordNoteController, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width, height: 30))
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemBlue
        label.text = NoteType(rawValue: section)?.title
        view.addSubview(label)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (NoteType(rawValue: section) == .audio && audioNotes.count > 0) || (NoteType(rawValue: section) == .text && textNotes.count > 0) {
            return 30
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if NoteType(rawValue: indexPath.section) == .audio {
                databaseController.deleteNote(for: audioNotes[indexPath.row].noteId!)
                audioNotes.remove(at: indexPath.row)
            } else {
                databaseController.deleteNote(for: textNotes[indexPath.row].noteId!)
                textNotes.remove(at: indexPath.row)
            }
            if textNotes.count == 0 && audioNotes.count == 0 { showErrorLabel() }
            tableView.reloadData()
        }
    }
}

enum NoteType: Int, CaseIterable {
    case audio
    case text

    var title: String {
        switch self {
        case .audio:
            return "Audio notes"
        case .text:
            return "Text notes"
        }
    }
}
