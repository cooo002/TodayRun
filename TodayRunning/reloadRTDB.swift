//
//  reloadRTDB.swift
//  TodayRunning
//
//  Created by 김재석 on 27/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
// note: 이 객체는 방의 대한 정보를 얻어오거나, uid 검색을 통해 해당 uid에 해당하는 유저의 정보를 얻어오는 객체

import Foundation
import Firebase
import UIKit

class reloadRTDB: UIViewController {
    //note: RTDB에서 방정보를 가져와서 그것을 저장하는 dic, arr 이다.
    var notictlist : Dictionary<String, Any>?
    var titleArr : Array<String>  = []// 각 방의 타이틀이 들어간다
    var infoArr: Array<Dictionary<String, Any>> = []
    
    //note: RTDB에서 유저 정보를 가져와서 그것을 저장하는 di,arr 이다.
    var attempPersonNumArr : Array<String> = [] // note: 타이틀을 저장하는 배열
    var userInfoDic : Dictionary<String, String>?

    //note : RTDBD에서 추천스팟에 대한 정보를 가져와서 그것을 저장하는 dic, arr 이다.
    var recomendSpotInfoDic : Dictionary<String, Any>?
    var recomendSpotInfoArr : Array<Dictionary<String, Any>> = []
    
    //note: RTDBD에서 OpenAPI의 정보를 가져와서 저장하는  arr 이다 .
    var OpenAPIDataInfoDic : Dictionary<String, Any>?
    var OpenAPIDataInfoArr : Array<Dictionary<String, Any>> = []
    var OpenAPIDataInfoForRecomendArr : Array<Dictionary<String, Any>> = []
    
    //note: RTDB에서 검색한 특정 추천스팟에 대한 정보
    var recomendSpotMadeUserDic : Dictionary<String, Any>?
    
    
    func noticeInfoReload( _ log : (() -> Void)?, _ completion : @escaping () -> (Void) ){
        var ref = Database.database().reference()
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var signUp = appDelegate.userProperty.readBool(key: "signUP")
//        var signUp = false
       
        
        ref.child("ios/runnigNoticeBoard").observe(DataEventType.value, with:{(snapshot) in//note:  한번 리스너가 연결되어 호출되면 이후 해당 경로를 포함한 하위 데이터의 변경일 있을 때만다 이 리스너가 호출된다.
            
            // note: 확인 해보니 인자로 전달 받은 클로져가 해당 함수가 종료되고 바로 실행되는게 아닌것 같아.다른 메소드를 실행하고 그 다음에 클로져의 정의된 내용을 실행하게된다. (이유를 알자!
            
            self.notictlist?.removeAll()
            self.titleArr.removeAll()
            self.infoArr.removeAll()
            

            self.notictlist = snapshot.value as? Dictionary<String, Any>
            //            note:infoArr에 numOfPerson 이 nil이 아닐 경우 메인 뷰가 켜질수 있도록 해준다
             if self.notictlist != nil{
                DispatchQueue.global().sync { // note: 데이터 파싱을 우선적으로 할 수 있게 큐로 해준다
                    for (key, value) in self.notictlist!{
                        self.titleArr.append(key)
                        self.infoArr.append(value as! [String : Any])
                        print("value의 저장되는 값은?\(value as! Dictionary<String, Any>)")
                        print("value의 타입은? \(type(of: value))")
                        print("Divtionnary 타입을 저장하도록하는 infArr의 저장돈 값은? : \(self.infoArr)")
                        print("reloadRTDB에서 noticeInfoReload메소드 실행!!")
                    }
                    completion()
                    }
//                DispatchQueue.global().sync {
//                 appDelegate.selectVC(signUp)
//                }
            }
             else{
                print("reloadRTDB에서 noticeInfoReload메소드 실행!!")
//                appDelegate.selectVC(signUp)
                completion()
            }
        })
    }
    
    
    func serchingUserInfo(_ uid : String, _ select : @escaping () -> (Void)){  //note: 파라미터로 넘어온 uid에 해당하는 유저의 img url을 넘겨주는 메소드
        var ref = Database.database().reference()
        var userInfoLocalDic : Dictionary<String, String>?
        
        
        ref.child("ios/userInfo/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
            
            userInfoLocalDic = snapshot.value as? Dictionary<String, String>
//            print("userInfoLocalDic에 저장된 데이터는? \(userInfoLocalDic)")
            //note: 내가 파라미터로 받아온 uid에 따라서 해당 유저의 정보는 잘들어온다
            self.userInfoDic = userInfoLocalDic
            print("userInfoDic에 저장된 데이터는(serching 메소드에서 실행된 로그)? \(self.userInfoDic)")
            print("serchingUserInfo 메소드 실해!")
            select()
        }
    
//           print("일단 searchingUserInfo메소드에서 userInfoDic에 데이터가 들어감")
        
    
        }
    
    
    func attempCheck(_ crewTitle : String, _ attempPersonUid : Array<String> , _ execute : () -> (Void)){
        //note: 전달받은 방의 제목으로 RTDB에서 검색을하고 만약 일치하는게 있다면 그 방의 attempPerson 키에 새로 참여한 인원의 uid를 추가한다.
        var ref = Database.database().reference()
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var attempUid = attempPersonUid
        
        
        if attempUid.contains(appDelegate.userProperty.readString(key: "uid")!) {
            //note: attempPersonUid 에 현재 유저의 uid가 포함되어 있는 경우 (alert 창을 띄어서 현재 유저가 이미 이 방에 참여했다는 것을 알려주자!!!
            execute()
            
        }
        else{ //note : attempPersonUid 에 현재 ㅇ유저의 uidrk포함되어 있지 않다면 추가시켜 주는 로직
            attempUid.append(appDelegate.userProperty.readString(key: "uid")!)
            var childUpdate = [ "attempPersonUid" : attempUid]// note: 여기서 value 값에 배열이 들어가야한다!!!( 그래서 내가 생각한 방법은 기존에 attempPerson 배열을 가져와서 겨기다가 새롭게 추가되는 인원의 uid를 append 시키는 방법을 사용할 것이다.)
            ref.child("ios/runnigNoticeBoard/\(crewTitle)/").updateChildValues(childUpdate)
            
        }
    }
    
    //note: 추천스팟에 대한 데이터를 RTDB에서 불러오는 것
    func recommendSpotReload(_ completion: @escaping () -> (Void)){
        var ref = Database.database().reference()
        ref.child("ios/recomendRouteInfo").observe(DataEventType.value, with: { (snapshot) in
            //note: 값이 변경될 때 마다 실행된다.
            self.recomendSpotInfoDic = snapshot.value as? Dictionary<String, Any>
            
            if self.recomendSpotInfoDic != nil{
                for (key, value) in self.recomendSpotInfoDic!{
                    self.recomendSpotInfoArr.append(value as! [String : Any])
                }
                print("현재 recomendSpotArr에 저장된 데이터는 : \(self.recomendSpotInfoArr)")
                print("recomendSpotArr에서 첫번째 인덱스에 저장된 스파에대한 설명은 \(self.recomendSpotInfoArr[0]["title"])")
                completion() // note: AppDelegate에서 클로져 전달인수로 그냥 데이터 불러왔다는 로그를 찍어주는 로직을 전송해주고 이를 여기서 실행한다. 그러면 화면에 데이터를 다 불러왔다고 log가 찍힐 것이다 .
                
            }
            else{
                //note: 이 부분은  recomendSpotInfoDic에 아무 데이터도 들어오지 않았을 때 실행되는 로직
                print("현재 recomendSpotDic에 아무 정보도 없습니다.")
            }
            
            //note: 이 부분은 그냥 파싱한 데이터를 확인하는 용도이다.
            print("recomendRouteInfo: \(self.recomendSpotInfoDic)")
            print("recomendRouteInfo의 타입: \(type(of: self.recomendSpotInfoDic))")
            
        })
        
    }
    
    
//     func reloadOpenAPIData(){
//            var ref = Database.database().reference()
//
//
//            ref.child("OpenApiData/DATA/DATA").observe(DataEventType.value) { (snapshot) in
//
//                DispatchQueue.global().async {
//                    // note : 내가 이부분에 이렇게 dispatchQueue를 사용해서 작업순서를 조정하려함
//
//    //                self.OpenAPIDataInfoArr =  (snapshot.value as? Array<Dictionary<String, Any>>)!
//                    self.OpenAPIDataInfoDic =  snapshot.value as? Dictionary<String, Any>
//
//
//
//                    if self.OpenAPIDataInfoDic != nil{
//                        var radomIntArr = [arc4random_uniform(199),arc4random_uniform(199),arc4random_uniform(199)]
//
//                        for (key, value) in self.OpenAPIDataInfoDic!{
//                            self.OpenAPIDataInfoArr.append(value as! [String : Any])
//                        }
//
//                        print("OpneApi관련 데이터를 RTDB에서 앱으로 다 불러왔다!")
//                        print("현재 OpenApiDataArr에  저장된 데이터 중 1번째 인덱스에 포함된 데이터  : \(self.OpenAPIDataInfoArr[1])")
//
//                        for data in 0...radomIntArr.count-1 {
//                            self.OpenAPIDataInfoForRecomendArr.append(self.OpenAPIDataInfoArr[Int(radomIntArr[data])])
//                            print("openApi로 가져올 데이터중 무작위 3개를 뽑고 그 3개중 \(data)번째 데이터는? \(self.OpenAPIDataInfoForRecomendArr[data])")
//                        }
//
//                    }
//                    else{
//                        //note: 이 부분은  recomendSpotInfoDic에 아무 데이터도 들어오지 않았을 때 실행되는 로직
//                        print("현재 OpneApiDataDic에 아무 정보도 없습니다.")
//                    }
//                }
//
//            }
//        }
//
    func reloadOpenAPIData(){
        var ref = Database.database().reference()


        ref.child("OpenApiData/DATA/DATA").observe(DataEventType.value) { (snapshot) in

            DispatchQueue.global().async {
                // note : 내가 이부분에 이렇게 dispatchQueue를 사용해서 작업순서를 조정하려함

//                self.OpenAPIDataInfoArr =  (snapshot.value as? Array<Dictionary<String, Any>>)!
                self.OpenAPIDataInfoDic = snapshot.value as? Dictionary<String, Any>
                self.OpenAPIDataInfoArr = self.OpenAPIDataInfoDic!["DATA"] as! Array<Dictionary<String, Any>>
                
                print("OADInfoDic의 저장된 데이터는? \(self.OpenAPIDataInfoDic)")
                //                self.OpenAPIDataInfoArr =  (snapshot.value as? Array<Dictionary<String, Any>>)!



                if self.OpenAPIDataInfoArr != nil{
                    var radomIntArr = [arc4random_uniform(199),arc4random_uniform(199),arc4random_uniform(199)]
                    print("OpneApi관련 데이터를 RTDB에서 앱으로 다 불러왔다!")
                    print("현재 OpenApiDataArr에  저장된 데이터 중 1번째 인덱스에 포함된 데이터  : \(self.OpenAPIDataInfoArr[1])")
                    for data in 0...radomIntArr.count-1 {
                        self.OpenAPIDataInfoForRecomendArr.append(self.OpenAPIDataInfoArr[Int(radomIntArr[data])])
                        print("openApi로 가져올 데이터중 무작위 3개를 뽑고 그 3개중 \(data)번째 데이터는? \(self.OpenAPIDataInfoForRecomendArr[data])")
                    }
                }
                else{
                    //note: 이 부분은  recomendSpotInfoDic에 아무 데이터도 들어오지 않았을 때 실행되는 로직
                    print("현재 OpneApiDataDic에 아무 정보도 없습니다.")
                }
            }

        }
    }
//

    
    func recomendSpotInfoByUser(_ autoID : String, _ select : @escaping () -> (Void)){
        var ref = Database.database().reference()
        ref.child("ios/recomendRouteInfo/\(autoID)").observeSingleEvent(of: .value) { (snapshot) in
            print("recmendSpotInfoByUser 메소드에 의해 반환된 snapshot의 타입은? \(type(of: snapshot.value!))")
            print("recmendSpotInfoByUser 메소드에 의해 반환된 snapshot의 저장된 데이터는? \( snapshot.value! as? Dictionary<String, Any> )")
            DispatchQueue.global().sync {
                self.recomendSpotMadeUserDic = snapshot.value! as? Dictionary<String, Any>
            }
            DispatchQueue.global().sync {
                print("recomendSpotMadeUserDic에 저장된 데이터는? \(self.recomendSpotMadeUserDic)")
                print("recomendSpotInfoByUser 메소드 실해!")
                select()
            }
           
        }
    }
    
    }

