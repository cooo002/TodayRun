//
//  recomendRouteMakeVC.swift
//  TodayRunning
//
//  Created by 김재석 on 18/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import UIKit
import NMapsMap

class recomendRouteMakeVC : UIViewController, UIScrollViewDelegate, UINavigationBarDelegate, NMFMapViewDelegate{
    
    var cameraLat = 37.5666102
    var cameraLng = 126.9783881
    var recomendSpotLat : Double?
    var recomendSpotLng : Double?
    var recomendSpotAddress : String?
    var NaverMapView : NMFNaverMapView?//note: 이걸 이렇게 프로퍼티로 만든 이유를 생각하자( 탑하였을 때 실행되는 didTap 메소드에서 마커를 찍을 네이버 지도 맵뷰에 접근하도록 하기 위해서 프로퍼티로 만들어 주고 클래스 내부 메소드에서 자유롭게 접근할 수 있도록 해주느 것이다. )
    var Marker = NMFMarker() //note: 이걸 이렇게 프로퍼티로 만든 이유를 생각하자( didTap 메소드 안에다 마커 객체를 만들어 놓으면 지도를 탭 할 때 마다 매번 새로운 마커가 만들어져서 지도에 탭한 만큼의 마커가 찍히게 된다 그래서 지도에 찍히는 마커의 갯수를 제한하기 위해서 이렇게 프로퍼티 빼고 탭을 할 때 마다 해당 마커의 mapView에 값이 nil인지 아닌지를 확인해 nil이면 기존 마커를 없애서 새로운 마커가 찍히게 해주는 것이다 .)
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var recomendRTTitle: UITextField!
    
    
    @IBOutlet weak var recomendReson: UITextView!
    
    @IBOutlet weak var recomendLocation: UITextField!
    
    
    @IBOutlet weak var recomendMapView: UIView!
    
    @IBAction func searching(_ sender: Any) {
        //note: 주소를 입력하고 검색 버튼을 누르면 실행되는 것
        self.areaNameToGeocoding(){
//            var view =  self.recomendMapView.subviews[0]//note: 원래 뷰의 서브 뷰를 변수에 할당한다.
            DispatchQueue.main.sync {
                
            
            self.NaverMapView = NMFNaverMapView(frame: CGRect(x: 0, y: 0, width: self.recomendMapView.frame.width, height: self.recomendMapView.frame.height))
            self.NaverMapView!.delegate = self
            var DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: self.cameraLat , lng: self.cameraLng ), zoom: 14, tilt: 0, heading: 0)
            self.NaverMapView!.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
            //
            //        let polyline = NMFPolylineOverlay(points: [
            //            NMGLatLng(lat: 37.57152, lng: 126.97714),
            //            NMGLatLng(lat: 37.56607, lng: 126.98268),
            //            NMGLatLng(lat: 37.56445, lng: 126.97707),
            //            NMGLatLng(lat: 37.55855, lng: 126.97822)])
            //        polyline?.mapView = self.NaverMapView?.mapView
            
//            view.removeFromSuperview()//note: 원래 뷰의 서브 뷰 자체를 "view"라는 변수로 할당했는데 그것의 서브뷰를 없애기 위해서는 해당
            // 해당 서브 뷰 자체를 없애면 된다. 그럴러면 해당 서브 뷰의 superView를 없애주면 된다.
            self.recomendMapView.addSubview(self.NaverMapView!)
            }
            
        }
    }
    
    
    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
        //    지도를 탭 했을 때 실행되는 메소드
        //        Note: 탭을 했을 때 세그먼트 컨트롤러의 인덱스 번호에 따라 도착지 인지 출발지 인지 체크하고 그에 따라 저장하자
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.recomendSpotLat = latlng.lat
        self.recomendSpotLng = latlng.lng
        print("파라미터 point의 값은?? \(point)")
        print("위도:\(self.cameraLat), 경도:\(self.cameraLng)")
        
        if self.Marker.mapView == nil{ //note: 마킹이 되어있지 않은 경우
            self.Marker.position = latlng
            self.Marker.mapView = self.NaverMapView?.mapView
            
        }
        else{ //note : 마킹이 되어있는 경우
            
            self.Marker.mapView = nil
            self.Marker.position = latlng
            self.Marker.mapView = self.NaverMapView?.mapView
            
        }

    }
    
    func addMapView( lat : Double, lng : Double){ // note 원래 뷰의 속한 가장 첫번재 서브뷰를 삭제하고 새로운 뷰룰 서브뷰로 등록하고
        //화면에 띄우는 방법
//        var view =  self.recomendMapView.subviews[0]//note: 원래 뷰의 서브 뷰를 변수에 할당한다.
        self.NaverMapView = NMFNaverMapView(frame: CGRect(x: 0, y: 0, width: self.recomendMapView.frame.width, height: self.recomendMapView.frame.height))
        self.NaverMapView!.delegate = self
        var DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: cameraLat , lng: cameraLng ), zoom: 14, tilt: 0, heading: 0)
        self.NaverMapView!.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
        self.recomendMapView.addSubview(self.NaverMapView!)
    }
    
    func areaNameToGeocoding(_ completion : @escaping ()->(Void)){
        var lat : Double!
        var lng : Double!
        let urlStr = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=\(self.recomendLocation.text!) &coordinate=127.1054328,37.3595963"
        
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
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            
            //            var places = json["places"] as! [[String : Any]]
            var addresses = json?["addresses"] as? [[String : Any]]
            print("address[0]의 들어가는 값 확인용 로그 \(addresses)")
            
            if addresses!.isEmpty{
//                  self.alertForNotMaiching()
                print("일치하는 검색 결과가 없다")
                DispatchQueue.main.sync {
                    let alert = UIAlertController(title: nil, message: "일치하는 지역이 없습니다 좀 더 정확히 입력해주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
                
            else{
            
                var roadAddress = addresses?[0]
                
                
                self.recomendSpotAddress = roadAddress?["roadAddress"] as! String
            
                self.recomendSpotAddress = roadAddress?["roadAddress"] as! String
                self.cameraLat = Double( roadAddress?["y"] as! String)!
                self.cameraLng = Double( roadAddress?["x"] as! String)!
            //                print("응답 결과:\n\(roadAddress as! String)") // note: 검색한 중심 지역의 위도가 저장되어있다.
                print("roadAddress의 저장된 데이터는 : \(roadAddress)")
                print("roadAddress의 타입? : \(type(of:roadAddress))") //note : any 타입이다
                print("위도 \n \(self.cameraLat), 타입은 \(type(of: self.cameraLat))")
                print("경도 \n \(self.cameraLng)")
            //         광진구
                completion()
            }
        }
        task.resume()
    }
    
    func alertForNotMaiching(){
        let alert = UIAlertController(title: nil, message: "일치하는 지역이 없습니다 다시 입력해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "추천루트"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButtonPress(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(uploadRrcomendRoute(_:)))
        self.addMapView(lat: self.cameraLat, lng: self.cameraLng)
        
    }
    
    @objc func backButtonPress(_ sender: Any){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func uploadRrcomendRoute(_: Any){
        //note: 추천루트를 업로드 하는 로직(아직 구상하지 로직을 짜지 않음)
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var dataSendFB = dataSendFireBase(spotLat: self.recomendSpotLat!, spotLng: self.recomendSpotLng!, title: self.recomendRTTitle.text!, reson: self.recomendReson.text, address: self.recomendSpotAddress!)
        dataSendFB.sendDataRTDBForRecomendSpot()
        self.presentingViewController?.dismiss(animated: true){
            appDelegate.ReloadRTDB.recommendSpotReload(){
                //note : recomendSpotReload의 클로져를 매개변수로 전달시킴
                print("recomendSpotReload메소드가 실행되어서 RTDB에 데이터를 가져옴")
            }
        }
        
        
    }
    
    
}

