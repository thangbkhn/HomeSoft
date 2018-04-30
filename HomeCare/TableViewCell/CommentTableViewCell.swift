//
//  CommentTableViewCell.swift
//  HomeCare
//
//  Created by Thang BKHN on 4/30/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var tvUser: UILabel!
    @IBOutlet weak var tvDate: UILabel!
    @IBOutlet weak var tvComment: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
