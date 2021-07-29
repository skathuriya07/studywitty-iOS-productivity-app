//
//  SessionsTableViewCell.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 30/05/21.
//

import UIKit

// This file and the xib file for SessionsTableViewDelegate has bee made after
// learning from this youtibe video: https://www.youtube.com/watch?v=epo_cxZy2Pc"

protocol SessionsTableViewDelegate {
    func onAccessoryClick(_ session: String)
}

class SessionsTableViewCell: UITableViewCell {

    static let cellID = "SessionsTableViewCell"
    var delegate: SessionsTableViewDelegate!
    var session: String!

    @IBOutlet weak var accessoryButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onAccessoryButtonDidClick(_ sender: Any) {
        delegate.onAccessoryClick(session)
    }
}
