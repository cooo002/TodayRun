//
//  TargetLocationMapVC.swift
//  TodayRunning
//
//  Created by 김재석 on 14/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import NMapsMap



class TargetLocationMapVC: UIViewController, NMFMapViewDelegate {
    //    var naverMapView: NMFNaverMapView!
    //    var mapView: NMFMapView!
    var touch_lat: Double!
    var touch_lng: Double!
    var img : UIImage?
    var defaultLat = 37.5666102
    var defaultLng = 126.9783881
    var centerLocation : String!

    var NaverMapView : NMFNaverMapView?//note: 이걸 이렇게 프로퍼티로 만든 이유를 생각하자( 탑하였을 때 실행되는 didTap 메소드에서 마커를 찍을 네이버 지도 맵뷰에 접근하도록 하기 위해서 프로퍼티로 만들어 주고 클래스 내부 메소드에서 자유롭게 접근할 수 있도록 해주느 것이다. )
    var Marker = NMFMarker() //note: 이걸 이렇게 프로퍼티로 만든 이유를 생각하자( didTap 메소드 안에다 마커 객체를 만들어 놓으면 지도를 탭 할 때 마다 매번 새로운 마커가 만들어져서 지도에 탭한 만큼의 마커가 찍히게 된다 그래서 지도에 찍히는 마커의 갯수를 제한하기 위해서 이렇게 프로퍼티 빼고 탭을 할 때 마다 해당 마커의 mapView에 값이 nil인지 아닌지를 확인해 nil이면 기존 마커를 없애서 새로운 마커가 찍히게 해주는 것이다 .)

    
//    var DEFAULT_CAMERA_POSITION : NMFCameraPosition?
    
  
    @IBOutlet weak var areaName: UITextField!
    
    @IBOutlet weak var mapView: UIView! // 네이버 맵 뷰가 띄어지는 뷰
    
    @IBOutlet weak var viewSelectSegment: UISegmentedControl!
    
    @IBAction func selectViewAction(_ sender: Any) {
        switch viewSelectSegment.selectedSegmentIndex {
            
        case 0:
            self.addExplanationView(uiImg: self.img!)
        case 1:
            self.addMapView(lat: self.defaultLat, lng: self.defaultLng)
        case 2:
            self.addMapView(lat: self.defaultLat, lng: self.defaultLng)
        default:
            print("세그먼트 컨트롤러를 탭하였다!")
        }
    }
    
    @IBAction func moveCamera(_ sender: Any) { //note : 중심지역을 검색하면 실행되는 액션 메소드
        

        DispatchQueue.global().sync {
            self.areaNameToGeocoding()
        }
        DispatchQueue.global().sync {
            self.addMapView(lat: self.defaultLat , lng: self.defaultLng)
        }
//
    }
    
    
    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
//    지도를 탭 했을 때 실행되는 메소드
        //        Note: 탭을 했을 때 세그먼트 컨트롤러의 인덱스 번호에 따라 도착지 인지 출발지 인지 체크하고 그에 따라 저장하자
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        touch_lat = latlng.lat
        touch_lng = latlng.lng
        print("파라미터 point의 값은?? \(point)")
        print("위도:\(touch_lat!), 경도:\(touch_lng!)")
        
     
        if self.Marker.mapView == nil{ //note: 마킹이 되어있지 않은 경우
            self.Marker.position = latlng
            self.Marker.mapView = self.NaverMapView?.mapView
        }
        else{ //note : 마킹이 되어있는 경우
            
            self.Marker.mapView = nil
            self.Marker.position = latlng
            self.Marker.mapView = self.NaverMapView?.mapView
            
        }
        
        if self.viewSelectSegment.selectedSegmentIndex == 1{//note: 출발지를 선택할 때
            appDelegate.boardInfo.departureLat = latlng.lat
            appDelegate.boardInfo.departureLng = latlng.lng
            print("boardInfo의 저장된 춟발지 위도\( appDelegate.boardInfo.departureLat), 경도\(appDelegate.boardInfo.departureLng)")
            
        }
        else{ // note: 도착지를 선택할 때
            appDelegate.boardInfo.destinationLat = latlng.lat
            appDelegate.boardInfo.destinationLng = latlng.lng
                 print("boardInfo의 저장된 도착지 위도\( appDelegate.boardInfo.destinationLat), 경도\(appDelegate.boardInfo.destinationLng)")
        }
        
    }
    
    func addMapView( lat : Double, lng : Double){ // note 원래 뷰의 속한 가장 첫번재 서브뷰를 삭제하고 새로운 뷰룰 서브뷰로 등록하고
        //화면에 띄우는 방법
        var view =  self.mapView.subviews[0]//note: 원래 뷰의 서브 뷰를 변수에 할당한다.
        self.NaverMapView = NMFNaverMapView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: self.mapView.frame.height))
        self.NaverMapView!.delegate = self
        var DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: lat , lng: lng ), zoom: 14, tilt: 0, heading: 0)
        self.NaverMapView!.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
//
//        let polyline = NMFPolylineOverlay(points: [
//            NMGLatLng(lat: 37.57152, lng: 126.97714),
//            NMGLatLng(lat: 37.56607, lng: 126.98268),
//            NMGLatLng(lat: 37.56445, lng: 126.97707),
//            NMGLatLng(lat: 37.55855, lng: 126.97822)])
//        polyline?.mapView = self.NaverMapView?.mapView

//        view.removeFromSuperview()//note: 원래 뷰의 서브 뷰 자체를 "view"라는 변수로 할당했는데 그것의 서브뷰를 없애기 위해서는 해당
        // 해당 서브 뷰 자체를 없애면 된다. 그럴러면 해당 서브 뷰의 superView를 없애주면 된다.
        self.mapView.addSubview(self.NaverMapView!)
    }
    
    
    func addExplanationView(uiImg :UIImage){//note: 출발, 도착지 마킹전에 어떻게 사용하는 설명이 적힌 뷰를 만들어주는 메소드
        var view =  self.mapView.subviews[0]
        let imgView = UIImageView()
        imgView.frame.size = CGSize(width: self.mapView.frame.height, height: self.mapView.frame.width)
        imgView.center = CGPoint(x: self.mapView.frame.width/2, y: self.mapView.frame.height/2)
        imgView.image = uiImg
        view.removeFromSuperview()
        self.mapView.addSubview(imgView)
    }
    
   

    func areaNameToGeocoding(){
        var lat : Double!
        var lng : Double!
        let urlStr = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=\(self.areaName.text!) &coordinate=127.1054328,37.3595963"
        
        let enconded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed )
    
        let urls = URL(string: enconded!)!
        var request = URLRequest(url: urls)
        request.httpMethod = "GET"
        request.addValue("ra3fwyfwi4", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue("h9RByDazaDLqsnS4jYun5vG4IrmCyk8C7buM0Jr7", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        
        let task = URLSession.shared.dataTask(with: request){ data , response , error in
            if let e = error{
                NSLog("에러 내용은? \(error)")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
            
            //            var places = json["places"] as! [[String : Any]]
            var addresses = json["addresses"] as! [[String : Any]]
            
            var roadAddress = addresses[0]["roadAddress"]
            self.centerLocation = addresses[0]["roadAddress"] as! String
            self.defaultLat = Double( addresses[0]["y"] as! String)!
            self.defaultLng = Double( addresses[0]["x"] as! String)!
            
//            self.DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: lat , lng: lng ), zoom: 14, tilt: 0, heading: 0)
       
            //note: any타입을 바로 double로 바꿀수는 없다 그래서 위와 같이 일단 string으로 바꾼 후 다시 double로 바꾸면된다 .
            //            print("응답 결과:\n\(places)")
            print("응답 결과:\n\(roadAddress as! String)") // note: 검색한 중심 지역의 위도가 저장되어있다.
            print("roadAddress의 타입? : \(type(of:roadAddress))") //note : any 타입이다
            print("위도 \n \(self.defaultLat), 타입은 \(type(of: self.defaultLat))")
            print("경도 \n \(self.defaultLng)")
//         광진구
         
        }
        
        task.resume()
        
    }
    
    @objc func areaMarkerTask(_ sender : Any){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.boardInfo.location = self.centerLocation
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img = UIImage(named:"profile-bg")
        let imgView = UIImageView()
        imgView.frame.size = CGSize(width: self.mapView.frame.height, height: self.mapView.frame.width)
        imgView.center = CGPoint(x: self.mapView.frame.width/2, y: self.mapView.frame.height/2)
        imgView.image = self.img
        self.mapView.addSubview(imgView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.areaMarkerTask(_:)))
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    

    
}
