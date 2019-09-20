//
//  recomandCourseVC.swift
//  TodayRunning
//
//  Created by 김재석 on 15/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import Floaty
class recomandCourseVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageImgArr = ["fallCourse.png", "seoulCourse.png"]//note: 이 이미지는 상단의 추천스팟 이미지 뷰에 들어가는 이미지이다 .
    
 
    
    @IBOutlet weak var verticalScrollView: UIScrollView!
    
    @IBOutlet weak var recomandTableView: UITableView!
    
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.ReloadRTDB.recomendSpotInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recomandCell",  for: indexPath) as! recomandCell
       
        cell.courseImg.layer.cornerRadius = cell.courseImg.frame.width / 2
        cell.courseImg.clipsToBounds = true
        cell.courseName.text =  self.appDelegate.ReloadRTDB.recomendSpotInfoArr[indexPath.row]["title"] as! String
        cell.courseAddress.text = self.appDelegate.ReloadRTDB.recomendSpotInfoArr[indexPath.row]["address"] as! String
        cell.courseImg.sd_setImage(with: URL(string: self.appDelegate.ReloadRTDB.recomendSpotInfoArr[indexPath.row]["imgUrl"] as! String))
//        cell.courseName.text
//        cell.courseAddress.text
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recomandTableView.delegate = self
        self.recomandTableView.dataSource = self
    
        self.horizontalScrollView.delegate = self
        self.pageControl.numberOfPages = self.pageImgArr.count
        self.pageControl.currentPage = 0
        
        for i in 0..<self.pageImgArr.count{
            var imageView = UIImageView()
            imageView.image = UIImage(named: self.pageImgArr[i])
            imageView.contentMode = .scaleAspectFit//note: 이미지를 이미지 뷰에 맞춰주는 코드
            let xPosition = self.view.frame.width * CGFloat(i)//note: 하나의 이미지 뷰가 만들어질
// 때 마다 그 새로운 이미지의 뷰의 x좌표를 정해줘야하는데 이 좌표를 자동으로 설정해주기 위한 변수
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.pageView.frame.width, height:
                self.pageView.frame.width)//note: 새로운 이미지 뷰의 크기 및 위치
            self.horizontalScrollView.contentSize = CGSize(width: self.pageView.frame.width*CGFloat(1+i), height: self.pageView.frame.height)//note: 스크롤 뷰의 컨텐츠 뷰를
      
            self.horizontalScrollView.addSubview(imageView)
            
        }
//        self.horizontalScrollView.bringSubviewToFront(pageControl)
                self.pageView.bringSubviewToFront(pageControl)
        
        let floaty = Floaty()
        floaty.addItem(title: "방 만들기", handler: { item in
            self.performSegue(withIdentifier: "moveRecomendRouteSegue", sender: nil)
//            var recomendRouteVC =
            
        })
        
        floaty.size = 30
        floaty.itemSize = 29
        self.view.addSubview(floaty)
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.recomandTableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / self.pageView.frame.width)
        self.pageControl.currentPage = Int(CGFloat(currentPage))
    }
}
