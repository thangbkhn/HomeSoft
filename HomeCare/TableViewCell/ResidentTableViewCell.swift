//
//  ResidentTableViewCell.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/28/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ResidentTableViewCell: MGSwipeTableCell {
    var onClick:(()-> Void)? = nil
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var txtFullName: UILabel!
    @IBOutlet var txtDateOfBirth: UILabel!
    @IBOutlet var txtGender: UILabel!
    @IBOutlet var imgOwner: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btDetail(_ sender: Any) {
        if self.onClick != nil{
            onClick!()
        }
    }
}
