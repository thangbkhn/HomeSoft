//
//  ReplyCommentTableViewCell.swift
//  HomeCare
//
//  Created by Thang BKHN on 5/1/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class ReplyCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var tvUser: UILabel!
    @IBOutlet weak var tvContent: UILabel!
    @IBOutlet weak var tvDate: UILabel!
    
    var replyAction:(()->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btReply(_ sender: Any) {
        if replyAction != nil{
            replyAction!()
        }
    }
}
