//
//  FeedbackTableViewCell.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/23/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class TicketTableViewCell: MGSwipeTableCell {
    @IBOutlet var txtTitle: UILabel!
    @IBOutlet var txtDate: UILabel!
    @IBOutlet var txtContent: UILabel!
    @IBOutlet var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
