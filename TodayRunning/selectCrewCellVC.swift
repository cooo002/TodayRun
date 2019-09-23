//
//  selectCrewCellVC.swift
//  TodayRunning
//
//  Created by 김재석 on 07/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
// Todo: 일단 위치를 잡기위해 네이버 맵을 대층 띄어놨는데 이후에 데이블 뷰가 2개 다 나오게 되면 출발, 도착지로 중심이 되어서 화면에 출력되도록 하자!!

import Foundation
import UIKit
import Firebase
import NMapsMap
import SDWebImage


class selectCrewCellVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NMFMapViewDelegate{
    
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

    @IBAction func attempAction(_ sender: Any) { //note: 참여하기 버튼을 누를 경우 실행되는 메소드
        // note: uid를 매개변수로 날리고 그
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.ReloadRTDB.attempCheck( crewName.text!, self.attempPersonUidArr!) { () -> (Void) in
            let alert = UIAlertController(title: nil, message: "이미 참가한 상태입니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            
            self.present(alert, animated: true)
            print("attempCheck메소드의 클로져 인자 실행!!")
        }
        attempTableView.reloadData()
        
    }
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var departureMarker = NMFMarker()
        var destinationMarker = NMFMarker()
        
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
    
    
}
