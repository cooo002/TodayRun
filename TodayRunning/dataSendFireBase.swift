//
//  dataSendFireBase.swift
//  TodayRunning
//
//  Created by 김재석 on 09/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import Firebase

class dataSendFireBase{
    
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var Userproperty = PropetyList()//개인 정보가 저장된 propertyList 객체를 생성한다.
//    var Userproperty =//개인 정보가 저장된 propertyList 객체를 생성한다.
    let storageRef = Storage.storage().reference()
    var ref: DatabaseReference!
//    var sendStorage = imgSendStorage()
    var userStruct = UserStruct()
    
    var name : String?
    var gender: String?
    var birth : String?
    var imgStr : String?
    var uid : String?
    //
    
    var recomendAddress : String?
    var recomendSpotLat : Double? //note: 추천 스팟의 위도
    var recomendSpotLng : Double? //note: 추천 스팟의 경도
    var recomendTitle : String?
    var recomendReson : String?
    var recomendUserImgUrl : String?
    var recomendCourseImgUrl : String?
    
    
    
    
    init(name : String, gender: String, birth : String) {
        
        self.name = name
        self.gender = gender
        self.birth = birth
        
        self.appDelegate.userProperty.writeString(string: self.birth!, key: "birth")
        self.appDelegate.userProperty.writeString(string: self.name!, key: "naem")
        self.appDelegate.userProperty.writeString(string: self.gender!, key: "gender")
       
        print("이미지\(self.imgStr)")
    }
    
    
    init( spotLat : Double, spotLng : Double, title: String, reson: String, imgUrl : String){
        //note: 추천스팟에 대한 정보를 RTDB로 보내는 용도로 사용하는 인스턴스 생성 initiallization
        self.recomendSpotLat = spotLat
        self.recomendSpotLng = spotLng
        self.recomendTitle = title
        self.recomendReson = reson
        self.uid = self.appDelegate.userProperty.readString(key: "uid")
    }

    init( spotLat : Double, spotLng : Double, title: String, reson: String, address: String){
        //note: 추천스팟에 대한 정보를 RTDB로 보내는 용도로 사용하는 인스턴스 생성 initiallization
        self.recomendSpotLat = spotLat
        self.recomendSpotLng = spotLng
        self.recomendTitle = title
        self.recomendReson = reson
        self.recomendAddress = address
        self.uid = self.appDelegate.userProperty.readString(key: "uid")
        self.recomendUserImgUrl = self.appDelegate.userProperty.readString(key: "img")
    }
    
    
    func sendDataRTDBForRecomendSpot(){
        //completion리아는  클로져 인자를 추가하고 그 클로져 인자로 이미지를 업로드하는 메소드를 받아오자!!
        self.uid = self.appDelegate.userProperty.readString(key: "uid")
        //        var test_name = self.Userproperty.readString(key: "name")
        //        print("plist에 저장된 name? : \(test_name)")
        guard var img = self.appDelegate.userProperty.readString(key: "img") as String? else{
            
            print("값이 안 박혀서 이거 실행")
            return
            
        }
        print("RTDB 저장 직전의 프로퍼티 리스트에 저장된  이미지 Url확인용 이미지 url은 \(self.appDelegate.userProperty.readString(key: "img"))")
        ref = Database.database().reference()
        var key = ref.child("recomendRouteInfo").childByAutoId().key
        
        self.ref.child("ios/recomendRouteInfo/\(key!)/title").setValue(self.recomendTitle as! NSString)
        self.ref.child("ios/recomendRouteInfo/\(key!)/address").setValue(self.recomendAddress as! NSString)
        self.ref.child("ios/recomendRouteInfo/\(key!)/reson").setValue(self.recomendReson as! NSString)
        self.ref.child("ios/recomendRouteInfo/\(key!)/imgUrl").setValue(self.recomendUserImgUrl as! NSString)
        self.ref.child("ios/recomendRouteInfo/\(key!)/spotLat").setValue(self.recomendSpotLat as! Double)
        self.ref.child("ios/recomendRouteInfo/\(key!)/spotLng").setValue(self.recomendSpotLng as! Double)
        self.ref.child("ios/recomendRouteInfo/\(key!)/recomendSpotAutoID").setValue(key as! NSString)
      
        
        print("db로 데이터 업로드 완료!!")
        
    }
    
    
    
    func initUserPropertList(){
        self.appDelegate.userProperty.writeString(string: self.birth!, key: "birth")
        self.appDelegate.userProperty.writeString(string: self.name!, key: "naem")
        self.appDelegate.userProperty.writeString(string: self.gender!, key: "gender")
//        self.userStruct.name = self.name
//        self.userStruct.birth = self.birth
//        self.userStruct.gender = self.gender
        
        print("다른 값을 propertylist에 저장하면서 이 전에 저장된 uid은 \(self.appDelegate.userProperty.readString(key: "uid"))")
//        self.sendDataRTDB()
//        print("다른 값을 propertylist에 저장하면서 이 전에 저장된 이름은 \(self.Userproperty.readString(key: "name"))")
//        print("다른 값을 propertylist에 저장하면서 이 전에 저장한 이미지 Url확인용 이미지 url은 \(self.Userproperty.readString(key: "img"))")
        //        self.Userproperty.writeString(string: self.img!, key: "img")
        
    }
    
    func sendDataRTDB(){
        //        note: PropertyList에 저장된 모든 정보를 uid에 따라 저장하면된다.
        self.uid = self.appDelegate.userProperty.readString(key: "uid")
//        var test_name = self.Userproperty.readString(key: "name")
//        print("plist에 저장된 name? : \(test_name)")
        guard var img = self.appDelegate.userProperty.readString(key: "img") as String? else{
            
             print("값이 안 박혀서 이거 실행")
           return
            
        }
        print("RTDB 저장 직전의 프로퍼티 리스트에 저장된  이미지 Url확인용 이미지 url은 \(self.appDelegate.userProperty.readString(key: "img"))")
        ref = Database.database().reference()
        
        self.ref.child("ios/userInfo/\(uid!)/name").setValue(self.name as! NSString)
        self.ref.child("ios/userInfo/\(uid!)/gender").setValue(self.gender as! NSString)
        self.ref.child("ios/userInfo/\(uid!)/profileImg").setValue(img as! NSString)
        self.ref.child("ios/userInfo/\(uid!)/birth").setValue(self.birth as! NSString)
        
        print("db로 데이터 업로드 완료!!")
        
    }

    
}
