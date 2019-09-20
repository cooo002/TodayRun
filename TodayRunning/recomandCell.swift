//
//  recomandCell.swift
//  TodayRunning
//
//  Created by 김재석 on 16/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import UIKit

class recomandCell: UITableViewCell {
    
    @IBOutlet weak var courseImg: UIImageView! //note: 원래는 코스 이미지로 사용할려 했는데 중간의 유저 이미지로 용도가 바뀜
    
    
    @IBOutlet weak var courseName: UILabel!
    
    
    @IBOutlet weak var courseAddress: UILabel!
}
