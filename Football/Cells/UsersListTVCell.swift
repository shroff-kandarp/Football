//
//  UsersListTVCell.swift
//  Football
//
//  Created by Ravi on 24/09/17.
//  Copyright © 2017 Ravi. All rights reserved.
//

import UIKit

class UsersListTVCell: UITableViewCell {

    @IBOutlet weak var userPhoneLbl: MyLabel!
    @IBOutlet weak var userNameLbl: MyLabel!
    @IBOutlet weak var userPicImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
