//
//  HomePageTableHeaderView.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 30/05/21.
//

import UIKit

// This file and the xib file for HomePageTableHeaderActionDelegate has bee made after
// learning from this youtibe video: https://www.youtube.com/watch?v=epo_cxZy2Pc"

protocol HomePageTableHeaderActionDelegate {
    func onQuoteClicked()
}

class HomePageTableHeaderView: UITableViewHeaderFooterView {

    //MARK: - Outlets

    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!

    //MARK: - Properties

    var delegate: HomePageTableHeaderActionDelegate!
    private let helper = Helpers.sharedInstance

    //MARK: - Methods

    func configureUI() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250) //size
        // click action on a view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onQuoteDidClick))
        self.backgroundImageView.addGestureRecognizer(tapGesture)
        backgroundImageView.isUserInteractionEnabled = true

        quoteLabel.numberOfLines = 0
        quoteLabel.font = helper.quoteTextLabelFont()
        quoteLabel.textColor = helper.quoteLabelColor()
        authorNameLabel.font = helper.authorTextLabelFont()
        authorNameLabel.textColor = helper.authorLabelColor()
    }

    @objc func onQuoteDidClick() {
        delegate.onQuoteClicked()
    }
}
