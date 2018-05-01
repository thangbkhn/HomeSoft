//
//  ReplyCommentViewController.swift
//  HomeCare
//
//  Created by Thang BKHN on 5/1/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class ReplyCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tvUSer: UILabel!
    @IBOutlet weak var tvContent: UILabel!
    @IBOutlet weak var tvDate: UILabel!
    @IBOutlet weak var tvContentSend: UITextField!
    @IBOutlet weak var tbReply: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
    }
    override func viewWillAppear(_ animated: Bool) {
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(true)
    }
    @IBAction func btSend(_ sender: Any) {
    }
    @IBAction func btReply(_ sender: Any) {
        tvContentSend.text = "@\(tvUSer.text ?? "") "
        tvContentSend.becomeFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commmentCell", for: indexPath) as! ReplyCommentTableViewCell
        cell.tvContent.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.preservesSuperviewLayoutMargins = false
        cell.replyAction = {
            self.tvContentSend.text = "@\(cell.tvUser.text ?? "") "
            self.tvContentSend.becomeFirstResponder()
        }
        return cell
    }
    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
}
