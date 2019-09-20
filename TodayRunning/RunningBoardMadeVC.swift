//
//  RunningBoardMadeVC.swift
//  TodayRunning
//
//  Created by 김재석 on 14/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
// note : 위도와 경도를 저장하는 객체를 인스턴스 해서 실체화해서 거기 저장된 위도와 경도를 가져오고 여기서 제목과 공지사항과 정원 그리고 방을 개설한 유저의 uid를 가져온다.

import Foundation
import UIKit
import Firebase

class RunningBoardMadeVC:  UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var Userproperty = PropetyList()//개인 정보가 저장된 propertyList 객체를 생성한다.
    let storageRef = Storage.storage().reference()
    var ref: DatabaseReference!
    //    var sendStorage = imgSendStorage()
    var userStruct = UserStruct()
    
    
    
    var name : String?
    var imgStr : String?
    var uid : String?
    var departureLat : Double?//note: 일단 string으로 해놨는데 latlang의 데이터 타입을 보고 고치자!
    var departureLng : Double?
    var destinationLat : Double?
    var destinationLng : Double?
    var centerLocation : String?
//    var attempPersonArr : Array<String>? = []
    
    // note: 제목과 공지사항을 그냥 바로 넘긴다.

    @IBOutlet weak var notice: UITextView!
    @IBOutlet weak var boardTitle: UITextField! //note: 공지제목
    @IBOutlet weak var numOfPeople: UITextField!// note: 정원수
    @IBOutlet weak var areaConfilg: UILabel!// note: 출발지, 도착지 설정
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
    func boardInfoDataSend(){
        //        note: 아래 내용을 제외한 나머지는 따로 초기화하지 않고 그냥 가져오도록한다 .
        
        self.uid = self.Userproperty.readString(key: "uid")

        var attempPersonUidArr = [self.Userproperty.readString(key: "uid")!]
        
        self.imgStr = self.Userproperty.readString(key: "img")
        
        
//        guard var img = self.Userproperty.readString(key: "img") as String? else{
//
//            print("값이 안 박혀서 이거 실행")
//            return
//
//        }
        print("RTDB 저장 직전의 프로퍼티 리스트에 저장된  이미지 Url확인용 이미지 url은 \(self.Userproperty.readString(key: "img"))")
        ref = Database.database().reference()
        
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/title").setValue(self.boardTitle.text as! NSString)
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/captinUid").setValue(self.uid as! NSString)
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/captinImg").setValue(self.imgStr as! NSString)
    self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/numOfPeople").setValue(Int(self.numOfPeople.text!))
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/departureLat").setValue(self.departureLat  )
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/departureLnt").setValue(self.departureLng )
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/destinationLat").setValue(self.destinationLat)
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/destinationLnt").setValue(self.destinationLng )
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/title").setValue(self.notice.text as! NSString)
        
       
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/centerLocation").setValue(self.centerLocation! )
        self.ref.child("ios/runnigNoticeBoard/\(self.boardTitle.text!)/attempPersonUid").setValue(attempPersonUidArr) // note : 참여하는 인원들이 저장되는 키값이다( 방을 만들 때 자동적으로 방장을 참여하느 것이니 추가 시켜주자!)
        print("db로 데이터 업로드 완료!!")
        
    }
    
    
    @objc func sendData(_ send :Any){
        var appDele = AppDelegate()
        
        print("fireBase로 공지 data 보내기 선택")
        self.boardInfoDataSend()
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "런닝메이트 만들기"
        let sendDataBtn = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(sendData(_:)))
        self.navigationItem.rightBarButtonItem = sendDataBtn


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) { //note: 화면이 보일 때 마다 boardInfo에 저장된 위도, 경도롤 갱신!!
        self.departureLat = appDelegate.boardInfo.departureLat
        self.departureLng = appDelegate.boardInfo.departureLng
        self.destinationLat = appDelegate.boardInfo.destinationLat
        self.destinationLng = appDelegate.boardInfo.destinationLng
        self.centerLocation = appDelegate.boardInfo.location
    }
}


