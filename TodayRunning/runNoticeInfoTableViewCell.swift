//
//  runNoticeInfoTableViewCell.swift
//  TodayRunning
//
//  Created by 김재석 on 30/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//note: apd

import Foundation
import UIKit


class runNoticeInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boardImg: UIImageView!
    @IBOutlet weak var boardTtitle: UILabel!
    @IBOutlet weak var boardLocation: UILabel!
    @IBOutlet weak var attempPersonNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        initiallize
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
}
