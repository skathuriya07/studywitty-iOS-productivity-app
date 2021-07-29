//
//  TodoTableViewCell.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 25/05/21.
//

// This file and the xib file for TodoTableViewCell has bee made after
// learning from this youtibe video: https://www.youtube.com/watch?v=epo_cxZy2Pc"

import UIKit

protocol TodoAction {
    func markCompleted(id: String, status: Bool)
}

class TodoTableViewCell: UITableViewCell {

    static let cellID = "TodoTableViewCell"
    var delegate: TodoAction!
    private var todo: Todo!

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .systemFont(ofSize: 14)
        }
    }

    @IBOutlet weak var completionButton: UIButton! {
        didSet {
            completionButton.setImage(UIImage.init(systemName: "checkmark.circle"), for: .normal)
            completionButton.setImage(UIImage.init(systemName: "checkmark.circle.fill"), for: .selected)
            completionButton.adjustsImageWhenHighlighted = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            completionButton.isSelected = !completionButton.isSelected
            delegate.markCompleted(id: todo.id!, status: completionButton.isSelected)
        }
    }

    func configureUI(_ todo: Todo) {
        self.todo = todo
        titleLabel.text = todo.title
        completionButton.isSelected = todo.completionStatus
    }
}
