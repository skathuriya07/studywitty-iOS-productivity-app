//
//  GraphTableViewCell.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 08/06/21.
//

import UIKit
// This file and the xib file for GraphTableViewCell has bee made after
// learning from this youtibe video: https://www.youtube.com/watch?v=epo_cxZy2Pc"

class GraphTableViewCell: UITableViewCell {

    static let cellID = "GraphTableViewCell"

    @IBOutlet weak var graphView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
