//
//  HomePageTableViewCell.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 29/05/21.
//

// This file and the xib file for HomePageTableViewCell has bee made after
// learning from this youtibe video: https://www.youtube.com/watch?v=epo_cxZy2Pc"
import UIKit

class HomePageTableViewCell: UITableViewCell {

    static let cellID = "HomePageTableViewCell"

    //MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        iconImageView.tintColor = Helpers.sharedInstance.getThemeColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
