//
//  cellyVC.swift
//  TodayRunning
//
//  Created by 김재석 on 24/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import UIKit

class CellyVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("released homeviewcontroller")
    }
}
