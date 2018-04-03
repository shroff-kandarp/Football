//
//  ReportsUserListTVCell.swift
//  Football
//
//  Created by Ravi on 25/09/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class ReportsUserListTVCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateLblHeight: NSLayoutConstraint!
    @IBOutlet weak var userPhoneLbl: MyLabel!
    @IBOutlet weak var userNameLbl: MyLabel!
    @IBOutlet weak var userPicImgView: UIImageView!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var numOfMatchesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
