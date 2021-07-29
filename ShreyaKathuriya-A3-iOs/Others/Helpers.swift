//
//  Helpers.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 23/05/21.
//
// this class contains all methods that are used in multiple files

import UIKit
import UserNotifications

class Helpers {

    static let sharedInstance = Helpers()

    private init() {}

    // Create a local user notification and display
    func displayNotifications(text: String, title: String, identifier: String){
        //Creat notification content
        let content = UNMutableNotificationContent()
        let requestIdentifier = identifier
        content.body = text
        content.title = title

        //Notification trigger timer
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        //Get notification request
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)

        //Add notification to center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    //Create and display alert dialog 
    func showConfirmationDialog(_ title: String,_ message: String, displayOnController: UIViewController ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        displayOnController.present(alertController, animated: true, completion: nil)
    }

    func getDataBaseController() -> DataController? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.databaseController as? DataController
    }

    func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }

    func getNavBarTitleAttributes() -> [NSAttributedString.Key : Any] {
        [
            .font: UIFont.systemFont(ofSize: 20)
        ]
    }

    //MARK: - Colors

    func getThemeColor() -> UIColor {
        UIColor(red: 40.0/255.0, green: 167.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    }

    func saveNotesTextLabelColor() -> UIColor {
        UIColor.black
    }

    func saveNotesDetailTextLabelColor() -> UIColor {
        UIColor.gray
    }

    func showSessionsTextLabelColor() -> UIColor {
        UIColor.black
    }

    func showSessionsDetailTextLabelColor() -> UIColor {
        UIColor.gray
    }

    func quoteLabelColor() -> UIColor {
        UIColor.white
    }

    func authorLabelColor() -> UIColor {
        UIColor.white
    }

    //MARK: - Fonts

    func saveNotesTextLabelFont() -> UIFont {
        UIFont.systemFont(ofSize: 18)
    }

    func saveNotesDetailTextLabelFont() -> UIFont {
        UIFont.systemFont(ofSize: 10)
    }

    func showSessionsTextLabelFont() -> UIFont {
        UIFont.systemFont(ofSize: 18)
    }

    func showSessionsDetailTextLabelFont() -> UIFont {
        UIFont.systemFont(ofSize: 10)
    }

    func quoteTextLabelFont() -> UIFont {
        UIFont.italicSystemFont(ofSize: 25)
    }

    func authorTextLabelFont() -> UIFont {
        UIFont.systemFont(ofSize: 15)
    }
}

public enum BorderSide {
    case top, bottom, left, right
}

extension UIView {
    public func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = color
        self.addSubview(border)

        let topConstraint = topAnchor.constraint(equalTo: border.topAnchor)
        let rightConstraint = trailingAnchor.constraint(equalTo: border.trailingAnchor)
        let bottomConstraint = bottomAnchor.constraint(equalTo: border.bottomAnchor)
        let leftConstraint = leadingAnchor.constraint(equalTo: border.leadingAnchor)
        let heightConstraint = border.heightAnchor.constraint(equalToConstant: width)
        let widthConstraint = border.widthAnchor.constraint(equalToConstant: width)

        switch side {
        case .top:
            NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, heightConstraint])
        case .right:
            NSLayoutConstraint.activate([topConstraint, rightConstraint, bottomConstraint, widthConstraint])
        case .bottom:
            NSLayoutConstraint.activate([rightConstraint, bottomConstraint, leftConstraint, heightConstraint])
        case .left:
            NSLayoutConstraint.activate([bottomConstraint, leftConstraint, topConstraint, widthConstraint])
        }
    }
}
