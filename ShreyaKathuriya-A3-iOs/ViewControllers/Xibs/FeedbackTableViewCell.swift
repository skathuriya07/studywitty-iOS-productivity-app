//
//  FeedbackTableViewCell.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 06/06/21.
//

import UIKit

// This file and the xib file for FeedbackDelegate has bee made after
// learning from this youtibe video: https://www.youtube.com/watch?v=epo_cxZy2Pc"

protocol FeedbackDelegate {
    func selectedRating(level: FeedbackLevels)
}

class FeedbackTableViewCell: UITableViewCell {

    @IBOutlet var feedbackButtons: [UIButton]!

    static let cellID = "FeedbackTableViewCell"
    var delegate: FeedbackDelegate!
    private var buttonTag = 1

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureUI() {
        // adding star buttons: blank
        for button in feedbackButtons {
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.adjustsImageWhenHighlighted = false
            button.tag = buttonTag
            buttonTag += 1
        }
    }

    @IBAction func onFeedbackButtonDidClick(_ sender: UIButton) {
        //plane simply all buttons
        feedbackButtons.forEach { button in
            button.setImage(UIImage(systemName: "star"), for: .normal)
        }
        //fills the buttons for until selection
        for item in 0..<sender.tag {
            feedbackButtons[item].setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        delegate.selectedRating(level: FeedbackLevels(type: self.accessibilityIdentifier, level: Int32(sender.tag)))
    }
}
