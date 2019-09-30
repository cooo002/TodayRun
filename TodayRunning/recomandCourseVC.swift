//
//  recomandCourseVC.swift
//  TodayRunning
//
//  Created by 김재석 on 15/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
// 
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import Floaty
import XREasyRefresh

class recomandCourseVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageImgArr = ["fallCourse.png", "seoulCourse.png", "profile-bg.png"]//note: 이 이미지는 상단의 추천스팟 이미지 뷰에 들어가는 이미지이다 .
    
    var selectCellIndex : Int?
    var recomendSpotAutoID : String?
    
    var viewAppearCheckApiOrPeoplefrom : Bool? //note: true(셀을 클릭하여 세그실행), false(상단 배너에 위치한 이미지 뷰를 선택하어 세그가 실행)
    
 
    @IBOutlet weak var justCheckingLabel: UILabel!
    
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
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.viewAppearCheckApiOrPeoplefrom = true
        self.recomendSpotAutoID = self.appDelegate.ReloadRTDB.recomendSpotInfoArr[indexPath.row]["recomendSpotAutoID"] as! String // 이거 수정하자. 선택한 셀의 row를 굳이 보낼 필요가 없다. 왜냐면 밑에 로지긍로 이미 츄저가 제공하는 추천스팟에 대한 정보가 불려져 오기 때문이다. 그렇기 때문에 segue를 통해 전달할 데이터는 상단의 운영자가 제공하는 추천스팟의 인덱스만 넘기자!! 이 인덱스를 통해 RTDBD에 저장된 OPEN API로 얻은 추천 스팟에 대한 정보를 가져올 것이다.
        
        appDelegate.ReloadRTDB.recomendSpotInfoByUser(self.recomendSpotAutoID!) {
            self.performSegue(withIdentifier: "moveRecomendCourseSegue", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveRecomendCourseSegue"{
            if let destinationVC = segue.destination as? UINavigationController{
                let destinationRootVC = destinationVC.topViewController as! recomendCourseInfoVC
                destinationRootVC.viewAppearCheckApiOrPeopleTo = self.viewAppearCheckApiOrPeoplefrom
                           
                destinationRootVC.pageControlCurrentPage = self.pageControl.currentPage
                
            }
            
//            // note: 이 부분을 체크하자
           
        }
        else{
//
            print("올바르게 moveRecomendCourseSegue가 작동하지 않았다.")
    }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recomandTableView.delegate = self
        self.recomandTableView.dataSource = self
      
        self.horizontalScrollView.delegate = self
        self.pageControl.numberOfPages = self.pageImgArr.count
        self.pageControl.currentPage = 0
        
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.verticalScrollView.xr.addPullToRefreshHeader(refreshHeader: XRActivityRefreshHeader(), heightForHeader: 65, ignoreTopHeight: XRRefreshMarcos.xr_StatusBarHeight) {
                            // do request...
                   
        //                  self.tableView.reloadData()
                    self.recomandTableView.reloadData()
                    
                        self.verticalScrollView.xr.endHeaderRefreshing()
                        }
        
//  note: OpenAPIDataInfoForRecomendArr 에는 추천 코스에 대한 정보 중 랜덤 3개를 뽑아서 집어 넣는것이다.
        
        for i in 0 ..< appDelegate.ReloadRTDB.OpenAPIDataInfoForRecomendArr.count{
            var imageView = UIImageView()
//            imageView.image = UIImage(named: appDelegate.ReloadRTDB.OpenAPIDataInfoForRecomendArr[i]["p_img"] as! String)
//            var textLabel = UILabel()
////            textLabel.
//            textLabel.text = "뛰기 좋은 길"
//            textLabel.minimumScaleFactor = 20
            imageView.sd_setImage(with: URL(string: appDelegate.ReloadRTDB.OpenAPIDataInfoForRecomendArr[i]["p_img"] as! String), completed: nil)//note :  이 부분 부터 시작!!!
            imageView.contentMode = .scaleAspectFit//note: 이미지를 이미지 뷰에 맞춰주는 코드
            //note: 여기서 이미지 뷰를 탭 했을 경우 액션이 발행 하도록 해줘야 한다
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapRecognizer)
            
            let xPosition = self.view.frame.width * CGFloat(i)//note: 하나의 이미지 뷰가 만들어질
// 때 마다 그 새로운 이미지의 뷰의 x좌표를 정해줘야하는데 이 좌표를 자동으로 설정해주기 위한 변수
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.pageView.frame.width, height:
                self.pageView.frame.width)//note: 새로운 이미지 뷰의 크기 및 위치
            self.horizontalScrollView.contentSize = CGSize(width: self.pageView.frame.width*CGFloat(1+i), height: self.pageView.frame.height)//note: 스크롤 뷰의 컨텐츠 뷰를
//            imageView.addSubview(textLabel)
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
    
    @objc func tapGestureAction(_ sender : Any){
        
        // reload데이터에서 openApi 정보를 불러오는 로직을 만든다.
        self.viewAppearCheckApiOrPeoplefrom = false //note: false(상단 배너에 위치한 이미지 뷰를 선택했다는 것을 알려주기 위해 체크용으로 프로퍼티에 false를 저장하낟. )
        
        self.performSegue(withIdentifier: "moveRecomendCourseSegue", sender: nil)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / self.pageView.frame.width)
        self.pageControl.currentPage = Int(CGFloat(currentPage))
    }
}
