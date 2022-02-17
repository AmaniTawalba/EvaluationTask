//
//  ListTVC.swift
//  EvaluationTask
//
//  Created by Amani Tawalbeh on 2/17/22.
//

import UIKit

class ListTVC: UITableViewCell {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var extraLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
