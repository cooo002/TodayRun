//
//  MainViewController.swift
//  TodayRunning
//
//  Created by 김재석 on 03/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import SDWebImage
import XREasyRefresh
import CircleBar
import Floaty

class MainViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var cell : runNoticeInfoTableViewCell?
    var crewTitle: String?
    var notice : String?
    var destinationLat : Double?//note: 도착지에 대한 위도
    
    var destinationLng : Double?//note: 도착지에 대한 경도
    
    var departureLat : Double?//note: 출발지에 대한 위도
    
    var departureLng : Double?//note : 출발지에 대한 경도
    
    var attempPersonUidArr : Array<String>?

    var checkCellReloadNum : Int = 0
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.checkCellReloadNum = 0 // note: refresh 할 때 데이터 불러오는게 완료되었는지 확인하기 위한 체크용 변수
        return appDelegate.ReloadRTDB.titleArr.count
        
        
    }
    //    note: 방 만들기를 탭 했을 때 RTDB에 데이터를 파싱하여 그 값을 저장하는 배열이 있는데 그 배열에 numOfPerson 까지 저장되지 않아 메인VC로 돌아면 그 값이 없어서 앱이 멈치는 문제가 신기하게 시뮬이 아닌 실제 기기로 돌리니 해결되었다
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.checkCellReloadNum += 1
        //note : 셀을 만드는데 갑자기 저장소의 위치를 참조할 수 있게 변수로 만들어놓은 이유는 fireBaseUI를 사용해서 셀의 이미지 뷰에 적용시켜보기 위함이다
        self.cell = tableView.dequeueReusableCell(withIdentifier: "boardCell") as! runNoticeInfoTableViewCell
//        self.boardTitle.text = self.appDelegate.ReloadRTDB.titleArr?[indexPath.row] as! String
        self.cell?.boardImg.layer.cornerRadius = (self.cell?.boardImg.frame.width)! / 2
        self.cell?.boardImg.clipsToBounds = true

        
            
        
        self.cell!.boardTtitle.text = self.appDelegate.ReloadRTDB.titleArr[indexPath.row]
        print("cell 이 하나씩 만들어질 때 info에 저장된 값 확인용!: \(  type(of: self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["numOfPeople"]))")
        self.cell!.attempPersonNum.text = String(self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["numOfPeople"] as! Int)
        self.cell!.boardLocation.text = self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["centerLocation"] as! String
        print("attempPersonUid의 타입은 \(type(of: self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["attempPersonUid"] as! Array<String>))")

        
        
        self.cell?.boardImg.sd_setImage(with: URL(string:  self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["captinImg"] as! String))
        return self.cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       var cell = tableView.cellForRow(at: indexPath) as! runNoticeInfoTableViewCell
        
         self.crewTitle = self.appDelegate.ReloadRTDB.titleArr[indexPath.row] //note: 선택됨 셀의 타이틀이 저장된다.
        self.notice = self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["title"] as! String
        //      note: 선탣됨 셀의 공지사항이 저장된다.
        self.departureLat = self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["departureLat"] as! Double
        self.departureLng = self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["departureLnt"] as! Double
        self.destinationLat = self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["destinationLat"] as! Double
        self.destinationLng = self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["destinationLnt"] as! Double
        self.attempPersonUidArr = self.appDelegate.ReloadRTDB.infoArr[indexPath.row]["attempPersonUid"] as! Array<String>

        self.performSegue(withIdentifier: "selectedCellSegue", sender: nil)
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedCellSegue"{
                let destinationVC = segue.destination as! selectCrewCellVC
                    destinationVC.crewNotice = self.notice //note: 선택됨 셀의 notice 정보를 도착지 crewNotice 프로퍼티에 저장한다 .
                    destinationVC.crewTitle = self.crewTitle//note: 선택됨 셀의 타이틀 정보를 도착지에 crewTitle프로퍼티엦 저장한다.
                    destinationVC.departureLat = self.departureLat
                    destinationVC.departureLng = self.departureLng
                    destinationVC.destinationLat = self.destinationLat
                    destinationVC.destinationLng = self.destinationLng
                    destinationVC.attempPersonUidArr = self.attempPersonUidArr
            
                    
            //todo: 출발지와 도착지에 대한 위도, 경동 정보를 보내준다 &
            
        }
    }
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
            
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        //        let floaty = Floaty(frame : CGRect(x: self.view.frame.width - 35, y: self.view.frame.height - 100, width: 30, height: 30))
          let floaty = Floaty()
        floaty.addItem(title: "팀원 모으기!", handler: { item in
            self.performSegue(withIdentifier: "moveMakeRoomSegue", sender: nil)

        })
        floaty.sticky = true
        floaty.size = 30
        floaty.itemSize = 29
        self.view.addSubview(floaty)
        
        self.tableView.xr.addPullToRefreshHeader(refreshHeader: XRActivityRefreshHeader(), heightForHeader: 65, ignoreTopHeight: XRRefreshMarcos.xr_StatusBarHeight) {
                    // do request...
            self.tableView.reloadData()
            
                self.tableView.xr.endHeaderRefreshing()

                }
        print("메인 VC에서 viewDidLoad 실행!!")
        print("현재 이 타입은>? : \(type(of: self.appDelegate.ReloadRTDB.notictlist))")
        print("RTDB에 저장된 데이터는? : \(self.appDelegate.ReloadRTDB.notictlist)")//note : 파싱을 해야한다
        //            key value로 이뤄진 딕셔너리 타입을 일단 먼저 파싱하자
        print("titleArr의 타입은? : \(type(of: self.appDelegate.ReloadRTDB.titleArr))")//note : 파싱을 해야한다
        print("titleArr은 : \(self.appDelegate.ReloadRTDB.titleArr)")//note : 파싱을 해야한다
        print("titleArr의 엘레멘트 갯수 : \(self.appDelegate.ReloadRTDB.titleArr.count)")//note : 파싱을 해야한다
        print("infoArr의 타입은? : \(type(of: self.appDelegate.ReloadRTDB.infoArr))")//note : 파싱을 해야한다
//        print("infoArr은 : \(type(of: self.appDelegate.ReloadRTDB.infoArr[0]["numOfPeople"]) )")//note : 파싱을 해야한다
        print("mainView가 실행되면서 property에 저장된 현재 로그인한 유저의 정보는:\(self.appDelegate.userProperty.readString(key: "name"))")
        print("mainView가 실행되면서 property에 저장된 현재 로그인한 유저의 정보는:\(self.appDelegate.userProperty.readString(key: "uid"))")
        print("mainView가 실행되면서 property에 저장된 현재 로그인한 유저의 정보는:\(self.appDelegate.userProperty.readString(key: "gender"))")

        }

        
        
        
    
    
    override func viewWillAppear(_ animated: Bool) {
//        self.appDelegate.ReloadRTDB.reloadDataForViewWillAppear()
         self.navigationController?.navigationBar.isHidden = false// 뷰에서 네비게이션 바를 감춰주는 것
        self.tabBarController?.tabBar.isHidden = false//
    
//
    }
}


