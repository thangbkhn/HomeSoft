//
//  PaymentTableViewCell.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/19/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    @IBOutlet var tvDate: UILabel!
    @IBOutlet var tvSumFee: UILabel!
    @IBOutlet var tvMotorFee: UILabel!
    @IBOutlet var tvServiceFee: UILabel!
    @IBOutlet var tvWaterFee: UILabel!
    @IBOutlet var tvElectricFee: UILabel!
    @IBOutlet var tvNotifyDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
