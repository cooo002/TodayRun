//
//  selectCrewCellVC.swift
//  TodayRunning
//
//  Created by 김재석 on 07/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
// Todo: 일단 위치를 잡기위해 네이버 맵을 대층 띄어놨는데 이후에 데이블 뷰가 2개 다 나오게 되면 출발, 도착지로 중심이 되어서 화면에 출력되도록 하자!!
// note : 선택한 달리기 모임의 정보를 보여주는 VC 이다 .여기다가 게시판 기능을 추가히기 위해서 일단 상단 탭바 비슷한걸 만들자!

import Foundation
import UIKit
import Firebase
import NMapsMap
import SDWebImage
import FCAlertView




class selectCrewCellVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NMFMapViewDelegate{
    
    
    @IBOutlet weak var infoTapbar: UIButton!
    
    @IBOutlet weak var noticeBoardTapbar: UIButton!
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var notice: UITextView!
    
    @IBOutlet weak var map: UIView!
    
    @IBOutlet weak var attempTableView: UITableView!
    
    @IBOutlet weak var attemp: UIButton!
    
    @IBOutlet weak var crewName: UILabel!
    
    var NaverMapView : NMFNaverMapView?
    
    
    var crewTitle : String?
    
    var crewNotice : String?
    
    var destinationLat : Double?//note: 도착지에 대한 위도
    
    var destinationLng : Double?//note: 도착지에 대한 경도
    
    var departureLat : Double?//note: 출발지에 대한 위도
    
    var departureLng : Double?//note : 출발지에 대한 경도
    
    var attempPersonUidArr : Array<String>? //note: 참여한 사람들의 uid가 저장되는 배열
    
    var attempPersonInfoArr : Array<String>?
    
    var selectCrewIndex : Int? // 선택한 팀원 모집에 인데슥 번호를 저장하는 변수다.
    
    

    @IBAction func infoTapbarAction(_ sender: Any) {
        // 정보 탭바를 선택했을 때의 액션 메소드
        infoTapbar.backgroundColor = .gray
        noticeBoardTapbar.backgroundColor = .darkGray
        self.infoTapBarSelect()
        
    }
    @IBAction func noticeBoardTapbarAction(_ sender: Any) {
        // 게시판 탭바를 선택했을 때 액션 메소드
        noticeBoardTapbar.backgroundColor = .gray
        infoTapbar.backgroundColor = .darkGray
        self.noticeBoardTapBarSelect()
        
    }
    @IBAction func attempAction(_ sender: Any) { //note: 참여하기 버튼을 누를 경우 실행되는 메소드
        // note: uid를 매개변수로 날리고 그
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.ReloadRTDB.attempCheck( crewName.text!, self.attempPersonUidArr!, self) { () -> (Void) in
           var alert = FCAlertView()
                               
                       //        alert.delegate = self
                               alert.makeAlertTypeWarning()
                               alert.colorScheme = .gray
                               alert.firstButtonTitleColor = .white
                               alert.firstButtonBackgroundColor = .gray
                               
                               alert.addButton("확인") {
                                   print("빈칸 체크 용  경고창이 나오고 확인 버튼 클릭")
                                  
                               }
                       
                               alert.hideDoneButton = true

                               alert.showAlert(inView: self,
                                               withTitle: nil,
                                               withSubtitle: "빈칸을 전부 채워주세요!!",
                                               withCustomImage: nil,
                                               withDoneButtonTitle: nil,
                                               andButtons: nil)
        }
    }
    
//    var viewTapBarTop : UIView = UIView()
    var buttonTapBarItemInfo : UIButton?
    var buttonTapBarItemNotice  : UIButton?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.attempPersonUidArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! attempPersonCell
        cell.img.layer.cornerRadius = cell.img.frame.width / 2
        cell.img.clipsToBounds = true
        
        appDelegate.ReloadRTDB.serchingUserInfo(self.attempPersonUidArr![indexPath.row]){
             cell.name.text = appDelegate.ReloadRTDB.userInfoDic!["name"]
             cell.birth.text = appDelegate.ReloadRTDB.userInfoDic!["birth"]
            cell.gender.text = appDelegate.ReloadRTDB.userInfoDic!["gender"]
            cell.img.sd_setImage(with: URL(string: appDelegate.ReloadRTDB.userInfoDic!["profileImg"]!))
            print("userInfoDic의 타입은?  \(type(of:appDelegate.ReloadRTDB.userInfoDic))")
            print("userInfoDic에 저장된 값은? \(appDelegate.ReloadRTDB.userInfoDic)")
            print("attempPersonUidArr의 저장된 \(indexPath.row)번재 uid는? \(self.attempPersonUidArr![indexPath.row])")
            print("ateempTableView의  \(indexPath.row)번째 셀이 만들어짐")
        }
        return cell
    }
    
    @objc func onTabButtonBarItem(_ sender: UIButton){// note : 상단 탭 바 아이템을 선태하면 일어나는 로직을 자거하면 된는 액션 메소드이다
        
        self.buttonTapBarItemInfo?.isSelected = false
        self.buttonTapBarItemNotice?.isSelected = false
        
        sender.isSelected = true
        print(" 상단 탭 바 버튼 클릭됨")
        
        
    }
    func infoTapBarSelect(){
        // Todo: info tapbar 클랙햇을 때 실행되는 로직!!!
        
         print(" 메인화면에서 전달 받은 팅원 모집 공고에 참여한 유저의 uid 모음 : \(self.attempPersonUidArr)")
        
                self.navigationController?.navigationBar.isHidden = false
                var departureMarker = NMFMarker()
                var destinationMarker = NMFMarker()
                
        //        self.tabBarController?.tabBar.isHidden = true
        //
                var width = self.view.frame.width / 2
                var height : CGFloat = 30
                var x : CGFloat = 0
        //        var y :  CGFloat = 0
                var y :  CGFloat = 0
              
                self.notice.isEditable = false
                self.notice.text = self.crewNotice//note: 출발지에서 받아온 정보를 도착지에 뷰에 적용시키는 부분이다 .
                self.crewName.text = self.crewTitle
                
                
                self.attempTableView.delegate = self
                self.attempTableView.dataSource = self
                
                self.NaverMapView = NMFNaverMapView(frame: CGRect(x: 0 , y: 0, width: self.map.frame.width, height: self.map.frame.height))
                //note: 지도의 카메라의 위치를 출발지에 대한 위도, 경도로 설정해준다. 그르면 초기에 지도가 켜질때 이 위치를 기준으로 잡히게된다.
                self.NaverMapView!.delegate = self
                var DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: self.departureLat! , lng: departureLng! ), zoom: 14, tilt: 0, heading: 0)
                self.NaverMapView!.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
                
                departureMarker.position = NMGLatLng(lat: self.departureLat!, lng: self.departureLng!)
                departureMarker.captionText = "출발지"
                departureMarker.mapView = self.NaverMapView?.mapView
                
                destinationMarker.position = NMGLatLng(lat: self.destinationLat!, lng: self.destinationLng!)
                destinationMarker.captionText = "도착지"
                destinationMarker.mapView = self.NaverMapView?.mapView
                
                self.map.addSubview(self.NaverMapView!)
    }
    
    func noticeBoardTapBarSelect(){
        
//        self.view.subviews[1].removeFromSuperview()
        //이렇게 뷰에 대한 서브뷰인 스크롤 뷰를 지우면 그에 포함되는 뷰들인 버튼, 지도, textField 등도
        //전부 지워져서 그 다음 infoTapBarSelect() 메소드를 실행하면 해당 메소들 실해을 위해 존재해야하는
        //뷰들이 사라졌으니 정보를 뿌려주고싶어도 그 정보를 받아 줄 수 가 없어서 에러가 발생한다!! 이것을 수정하자
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // NARK: 이 로직 전부를 하나의 메소드로 만들고 탭을 클릭함으로써 새로운 뷰가 나오도록 하고 다시 돌아오면 해당 메소드
        //를 실행시켜서 초기 화면으로 보이도록 해주는 로직을 사용한다?? ( 일단 내 생각임!)
        self.infoTapBarSelect()
       
    }
    
    
}
