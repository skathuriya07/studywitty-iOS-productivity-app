//
//  TasksTableViewCell.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 06/06/21.
//

import UIKit
// This file and the xib file for TaskActionDelegate has bee made after
// learning from this youtibe video: https://www.youtube.com/watch?v=epo_cxZy2Pc"

protocol TaskActionDelegate {
    func markCompleted(id: String, status: Bool)
}

class TasksTableViewCell: UITableViewCell {

    static let cellID = "TasksTableViewCell"
    var delegate: TaskActionDelegate!
    private var task: Task!

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .systemFont(ofSize: 14)
        }
    }
    @IBOutlet weak var accessoryButton: UIButton! {
        didSet {
            accessoryButton.setImage(UIImage.init(systemName: "checkmark.circle"), for: .normal)
            accessoryButton.setImage(UIImage.init(systemName: "checkmark.circle.fill"), for: .selected)
            accessoryButton.adjustsImageWhenHighlighted = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //select the task to mark
        super.setSelected(selected, animated: animated)
        if selected {
            accessoryButton.isSelected = !accessoryButton.isSelected
            delegate.markCompleted(id: task.taskId!, status: accessoryButton.isSelected)
        }
    }

    func configureUI(_ task: Task) {
        self.task = task
        titleLabel.text = task.task
        accessoryButton.isSelected = task.completed
    }
}
