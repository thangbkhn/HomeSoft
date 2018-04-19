//
//  NotificationTableCell.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/19/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import  MGSwipeTableCell

class NotificationTableCell: MGSwipeTableCell {
    @IBOutlet var tvTitle: UILabel!
    @IBOutlet var tvToPerson: UILabel!
    @IBOutlet var tvContent: UILabel!
    @IBOutlet var img: UIImageView!
    @IBOutlet var tvDate: UILabel!
    @IBOutlet var imgAttachment: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
