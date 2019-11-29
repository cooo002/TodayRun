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
import FCAlertView


class reloadRTDB: UIViewController {
    //note: RTDB에서 방정보를 가져와서 그것을 저장하는 dic, arr 이다.
    var notictlist : Dictionary<String, Any>?
    var titleArr : Array<String>  = []// 각 방의 타이틀이 들어간다
    var infoArr: Array<Dictionary<String, Any>> = []
    //note:현재 앱의 만들어진 방에 대한 정보가 저장된 array다.
    
    
    //note: RTDB에서 유저 정보를 가져와서 그것을 저장하는 di,arr 이다.
    var attempPersonNumArr : Array<String> = [] // note: 타이틀을 저장하는 배열
    var userInfoDic : Dictionary<String, Any>? //note: <String, Any> 타입으로 바꿔줬다!! 원래는 <String, String> 타입이다.
    var userInfoCheckDic : Dictionary<String, String>?
    var userInfoDicValArr : Dictionary<String,Any>? //note:회원이 가입한 크루들의 명단을 저장하지 위해 일단
    // 해당 회원의 모든 정보를 array 타입의 value를 갖는 dictionary를 만들어준것이다.
    var userSignUpCrewList : Array<String> = []
    var signUpCrewInfoDic : Array<Dictionary<String, Any>> = [] // note: 현재 로그인한 유저가 가입한 방에 대한 정보가 담기는 Dictionay!!
    
    
    
    //note : RTDBD에서 추천스팟에 대한 정보를 가져와서 그것을 저장하는 dic, arr 이다.
    var recomendSpotInfoDic : Dictionary<String, Any>?
    var recomendSpotInfoArr : Array<Dictionary<String, Any>> = []
    
    //note: RTDBD에서 OpenAPI의 정보를 가져와서 저장하는  arr 이다 .
    var OpenAPIDataInfoDic : Dictionary<String, Any>?
    var OpenAPIDataInfoArr : Array<Dictionary<String, Any>> = []
    var OpenAPIDataInfoForRecomendArr : Array<Dictionary<String, Any>> = []
    
    //note: RTDB에서 검색한 특정 추천스팟에 대한 정보
    var recomendSpotMadeUserDic : Dictionary<String, Any>?
    
    var window : UIWindow?
    

    
    func researchingOfSignIn(_ uid : String, _ completion : () -> (Void)){
        // note : 로그아웃한 다음 구글로 다실 로그인 할 때 해당 아이디로 가입한 적이이 있는지 없는지를 확인하기위한 메소드
        var ref = Database.database().reference()
        var userInfoCheckDic : Dictionary<String, String>?
        var signInCheck : Bool?
        
                
                ref.child("ios/userInfo/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
            
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    userInfoCheckDic = snapshot.value as? Dictionary<String, String>
                    
                    if snapshot.value != nil{
                        //note :  이미 해당 아이디로 가입한 적이 있었다.
                        let secondStoryboard = UIStoryboard(name: "Second", bundle: nil)
                                           // 뷰 컨트롤러 인스턴스
                        let viewController = secondStoryboard.instantiateViewController(withIdentifier: "secondStoryBoard")
                                           
                                           // 윈도우의 루트 뷰 컨트롤러 설정
                        self.window?.rootViewController = viewController
                        
                        self.window?.makeKeyAndVisible()
                        
                    }
                    else{
                        // 처음 회원가입하는 경우 실행되는 로직이다 .
                         let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                                         let mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "_ProfileInit2")
                                         self.present(mainViewController, animated: true)
                    }
        //            print("userInfoLocalDic에 저장된 데이터는? \(userInfoLocalDic)")
                    //note: 내가 파라미터로 받아온 uid에 따라서 해당 유저의 정보는 잘들어온다
                }
   
    }
    
    func initNoticeInfoReload( _ log : (() -> Void)?, _ completion : @escaping () -> (Void) ){ // note : 앱 실행시 팀원 모집 정보를 가져온느 메소드
        var ref = Database.database().reference()
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var signUp = appDelegate.userProperty.readBool(key: "signUP")
//        var signUp = false
        defer{
            // note:화면이동 로직을 가장 마지막에 실행되도록 defer 구문을 사용햇다!!
        ref.child("ios/runnigNoticeBoard").observeSingleEvent(of: .value) { (snapshot) in
                    //note:  한번 리스너가 연결되어 호출되면 이후 해당 경로를 포함한 하위 데이터의 변경일 있을 때만다 이 리스너가 호출된다.
            
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
//                    self.signUpCrewJudgeMent()
                    
                    completion()
                    }
            }
             else{
                print("reloadRTDB에서 noticeInfoReload메소드 실행!!")
                completion()
            }
            }
        }
    } // note : observer 의 끝!!!!
    
    
    
    
      func noticeInfoReload( _ log : (() -> Void)?, _ completion : @escaping () -> (Void) ){
            var ref = Database.database().reference()
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            var signUp = appDelegate.userProperty.readBool(key: "signUP")
    //        var signUp = false
        ref.child("ios/runnigNoticeBoard").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
        //note:  한번 리스너가 연결되어 호출되면 이후 해당 경로를 포함한 하위 데이터의 변경일 있을 때만다 이 리스너가 호출된다.
                
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
                }
                 else{
                    print("reloadRTDB에서 noticeInfoReload메소드 실행!!")
                    completion()
                }
            }
        }// note : observer 의 끝!!!!
        
    
    
    func serchingUserInfoAfterLogIn(_ uid : String, _ select : @escaping () -> (Void)){
        
        
        
        self.serchingUserInfo(uid) { () -> (Void) in
            var appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.userProperty.writeString(string: appDelegate.ReloadRTDB.userInfoDic!["profileImg"]! as! String, key:"img" )
            appDelegate.userProperty.writeString(string:  appDelegate.ReloadRTDB.userInfoDic!["name"]! as! String, key:"name")
            appDelegate.userProperty.writeString(string: appDelegate.ReloadRTDB.userInfoDic!["birth"]! as! String, key: "birth")
            appDelegate.userProperty.writeString(string: appDelegate.ReloadRTDB.userInfoDic!["gender"]! as! String, key: "gender" )
            
            select()
        }
    }
    
    func serchingUserInfo(_ uid : String, _ select : @escaping () -> (Void)){  //note: 파라미터로 넘어온 uid에 해당하는 유저의 img url을 넘겨주는 메소드
        var ref = Database.database().reference()
        var userInfoLocalDic : Dictionary<String, Any>?
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        ref.child("ios/userInfo/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
            
//            userInfoLocalDic = snapshot.value as! Dictionary<String, Any> as! Dictionary<String, String>
            userInfoLocalDic = snapshot.value as! Dictionary<String, Any>
            // note: 이 부분을 다운 캐스팅함!! 이것 기억하자!!!
//            self.userInfoDicValArr  = snapshot.value as? Dictionary<String, Array<String>>
//            print("userInfoLocalDic에 저장된 데이터는? \(userInfoLocalDic)")
            //note: 내가 파라미터로 받아온 uid에 따라서 해당 유저의 정보는 잘들어온다
            self.userInfoDic = userInfoLocalDic
            //  참여 크루 목록이 추가되면 그것을 받아올 때 해당 데이터를 받아오는 데이터 자료 구조가  Dictionary<String, String> 인데
            // 참여 가입 크루 목록이  Dictionary<String, Array<String>>이여서 데이터 저장이 안 되는거!!!)
            // 이런식으러 userInfoDic을 Dictionary<String, Any>? 타입으로 바꿔주자!!!
            
//            appDelegate.userSignUpCrewList.append(userInfoLocalDic!["signUpCrewList"]!)
            
            
            print("userInfoDic에 저장된 데이터는(serching 메소드에서 실행된 로그)? \(self.userInfoDic)")
            print("userInfoDicValArr에 저장된 데이터는(serching 메소드에서 실행된 로그)? \(self.userInfoDicValArr)")
            
            print("serchingUserInfo 메소드 실해!")
            select()
        }
    
        }
    
    
    func attempCheck(_ crewTitle : String, _ attempPersonUid : Array<String>,_ selectVC : selectCrewCellVC , _ execute : () -> (Void)){
        //note: 전달받은 방의 제목으로 RTDB에서 검색을하고 만약 일치하는게 있다면 그 방의 attempPerson 키에 새로 참여한 인원의 uid를 추가한다.
        var ref = Database.database().reference()
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var attempUid = attempPersonUid
        var selectVC = selectVC
        var userUid = appDelegate.userProperty.readString(key: "uid")
        
        if attempUid.contains(appDelegate.userProperty.readString(key: "uid")!) {
            // 참여하기 버튼을 누르면 해당 방안에 내가 참여해는지 검색을 하고 만약 참여한 상태이면 아래
            // 매개변수로 받아온 클로져를 실해하면 된다.
            
            execute()

            
        }
        else{ //note : attempPersonUid 에 현재 ㅇ유저의 uidrk포함되어 있지 않다면 추가시켜 주는 로직
            attempUid.append(appDelegate.userProperty.readString(key: "uid")!)
            var childUpdate = [ "attempPersonUid" : attempUid]// note: 여기서 value 값에 배열이 들어가야한다!!!( 그래서 내가 생각한 방법은 기존에 attempPerson 배열을 가져와서 겨기다가 새롭게 추가되는 인원의 uid를 append 시키는 방법을 사용할 것이다.)
//            var signUpCrewUpdate = [ "signUpCrew" : crewTitle]// 현재 가입한 크루의 제목들이 저장되는 딕셔너리이다.
       
            
            ref.child("ios/runnigNoticeBoard/\(crewTitle)/").updateChildValues(childUpdate)//ToDo: Db에 참여한 회원의 uid를 저장해주는 부분이다.
//            ref.child("ios/userInfo/\(userUid)/").updateChildValues(signUpCrewUpdate)
            
            self.updateSignUPCrewList(crewName: crewTitle)
//           execute()
            DispatchQueue.main.async {
                selectVC.attempTableView.reloadData()
            }
        }
          print("signUPCrewJudgemetn메소드의 실행결과 infoValue에 저장된 값은? \(self.userInfoDicValArr)")
        
    }
    
    func updateSignUPCrewList(crewName: String){//ToDo: 매개변수로 받은 크루의 이름을 이용해서 현 회원이 가입한 크루의 list를 최신화 해주는 메소드이다.
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var ref = Database.database().reference()
        var userUid = appDelegate.userProperty.readString(key: "uid")
        appDelegate.userSignUpCrewList.append(crewName)
//        reloadUserInfo()
//        for i in userInfoDic["signUpCrewList"]{
        
        var crewName = ["signUpCrewList":appDelegate.userSignUpCrewList]
//
//
        print("현재 userSignUpCrewList에 저장된 값은? : \(appDelegate.userSignUpCrewList)")
      
           //note: 아직 다른 크루를 한번도 가입한 적이 없는 상태이다 .
        defer {
        ref.child("ios/userInfo/\(userUid!)/").updateChildValues(crewName)
        }
        
    }
    
    func crewImgJudgeMentReload(crewName: String){
        //ToDo: 메소드가 시작되면 해당 방에 사진에 대한 url이 들어있는지 확인한다.!!!
        // 방에 활동 이미지가 있다면 그것을 배열에 담아둔다! 그리고 만약 방에 활동사진이 없다면
        // 해당 배열은 빈배열로둔다. 그리고 이제 collectionOfCrewPhotoVC이 시작되면 배열에 있는
        // 이미지를 하나씩 불러와서 셀에 반영해준다!
        // 그리고 활동사진을 추가하면 해당 배열에 srorage에 올린 이미지의 url을 배열에 추가시켜주고 해당 배열 자체를 통으로
        // 방 관련 db에 추가시켜준다.

        var ref = Database.database().reference()
        //        var userInfoLocalDic : Dictionary<String, Any>?
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        //
        print("crewImgJudgeMentReload가 실행되면서 넘겨받은 방의 이름은? \(crewName)")

        if crewName != nil {
            ref.child("ios/runnigNoticeBoard/\(crewName)/ActivityImgUrl").observeSingleEvent(of: DataEventType.value) { (snapshot) in
                //겅로에 데이터가 없으면 그냥 nil을 반환한다.
                    appDelegate.crewImgArray.removeAll()
            print("signUpCrewList에 저장된 snapShot.value의 값은? : \(type(of: snapshot.value!))")
                if snapshot.value! != nil && type(of: snapshot.value!) != NSNull.self {// note: signUpCrewList에 값이 있으니까 저장된 값을 가져와서 appDelegate.userCrewList에 저장해준다!!
                    appDelegate.crewImgArray.removeAll()
                    appDelegate.crewImgArray = snapshot.value as! Array<String>
                    print("현재 크루의 활동 사진은 다음과 같이 있습니다.\(appDelegate.crewImgArray)")
                        //
                    }
                else{
                    print("현재 크루의 활동 사진은 없습니다. ")
                    }
                }
              }
    }
    
    
    func signUpCrewJudgeMent(){
        //현재 유저의 정보를 불러오는 메소드이다.
        
        //ToDo: 처음에 이 메소드가 실행되면 현재 유저가 userInfoLocalDic이 비어있는지 안 비었는지 체크하고
        //비었으면 signUpCrewList를 RTDB에 만들어주고 signUpCrewList가 안 비어있으면 이번에 가입하려는 크루의 제목을
        //배열에 그대로 추가해준다.
        
//
        var ref = Database.database().reference()
//        var userInfoLocalDic : Dictionary<String, Any>?
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var uid = appDelegate.userProperty.readString(key: "uid")
//
        print("signUpCrewList가 실행되면서 현재 로그인한 유저의 uid는 \(uid)")

        if uid != nil {
        ref.child("ios/userInfo/\(uid!)/signUpCrewList").observeSingleEvent(of: DataEventType.value) { (snapshot) in
        //겅로에 데이터가 없으면 그냥 nil을 반환한다.
            print("signUpCrewList에 저장된 snapShot.value의 값은? : \(type(of: snapshot.value!))")
//            appDelegate.userSignUpCrewList = snapshot.value as! Array<String>
            
            if snapshot.value! != nil && type(of: snapshot.value!) != NSNull.self {// note: signUpCrewList에 값이 있으니까 저장된 값을 가져와서 appDelegate.userCrewList에 저장해준다!!
                
                //note: 분명 signUpCrewList에 저장된 값이 없는데 왜  값이 저장되어있다고 나오지??
                // nil을 강제로 Rj
                
                print("현재 로그인한 유저의 userInfo에는 singUpCrewList가 있습니다.")
                print("현재 로그인한 유저의 userInfo/signUpCrewList에 저장된 snapshot Value는? \(snapshot.value as! Array<Any>)")
                appDelegate.userSignUpCrewList = snapshot.value as! Array<String>
                self.userInfoDicValArr = snapshot.value as? Dictionary<String, Any>
                print("현재 로그인한 유저의 appDelegate.userSignUpCrewList에 저장된 값은? \(appDelegate.userSignUpCrewList)")
                //
            }
            else{
                  print("현재 로그인한 유저의 userInfo에는 singUpCrewList가 없습니다.")
            }
            defer{
                self.signUpCrewInfoExtraction()
            }

    }
        }
        print("스코프 밖에서 현재 로그인한 유저의 userInfo/signUpCrewList에 저장된 snapshot Value는? \(self.userInfoDicValArr)")
        
    }
    
    //note: 추천스팟에 대한 데이터를 RTDB에서 불러오는 것
    func recommendSpotReload(_ completion: @escaping () -> (Void)){
        var ref = Database.database().reference()
        
        ref.child("ios/recomendRouteInfo").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            //note: 값이 변경될 때 마다 실행된다.
            self.recomendSpotInfoArr.removeAll()
            self.recomendSpotInfoDic?.removeAll()
            
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
    
    //note: 추천스팟에 대한 데이터를 RTDB에서 불러오는 것
       func initRecommendSpotReload(_ completion: @escaping () -> (Void)){
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
       
    
//
    func reloadOpenAPIData(){ //note: 앱이 시작되면 일단 이 메소드 호출해서 db에 있는 데이터를 한번 쫙 받아온다.
        
        var ref = Database.database().reference()


        ref.child("OpenApiData/DATA/DATA").observe(DataEventType.value) { (snapshot) in
            //note : 원래 이전에는 data/data 가 경로였다

            DispatchQueue.global().async {
                // note : 내가 이부분에 이렇게 dispatchQueue를 사용해서 작업순서를 조정하려함

//                self.OpenAPIDataInfoArr =  (snapshot.value as? Array<Dictionary<String, Any>>)!
                print("snapshot.value에 저장된 값은?? \(snapshot.value)")
                self.OpenAPIDataInfoDic = snapshot.value as? Dictionary<String, Any>
             print("OADInfoDic의 저장된 데이터는? \(self.OpenAPIDataInfoDic)")
                self.OpenAPIDataInfoArr = self.OpenAPIDataInfoDic!["DATA"] as! Array<Dictionary<String, Any>>
                
//                print("OADInfoDic의 저장된 데이터는? \(self.OpenAPIDataInfoDic)")
                //                self.OpenAPIDataInfoArr =  (snapshot.value as? Array<Dictionary<String, Any>>)!



                if self.OpenAPIDataInfoArr != nil{
                    var radomIntArr = [arc4random_uniform(131),arc4random_uniform(131),arc4random_uniform(131)]
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
    // check: 회원이 가입한 크루의 정보를 뽑아오는 메소들 만들기부터 시작하기!!
    func signUpCrewInfoExtraction(){
        // ToDo: 가입한 크루의 정보를 추출하는 메소드
        // note: 비동기로 돌아가도록 해줘야한다.(signUpCrewList메소드 실행 후 바로 실행할 것이다.)
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var ref = Database.database().reference()
        //note: appDelegate.userSignUpCrewList에 저장된 가입한 크루의 제목을 불러와서 그 제목으로 방에 대한 정보를 찾아와서 하는게 나은 방법??
        //      VS 그냥 현재 앱에 만들어진 모든 방에 대한 정보를 전부 가져와서 그것을 따로 분류하는 것이 맞나???
        signUpCrewInfoDic.removeAll() //note: 일단 빈배열로 만들어준다.
        
        for i in appDelegate.userSignUpCrewList{
        //note: userSignUpCrewList에 저장된 제목들을 하나씩 불러오는 과정
            ref.child("ios/runnigNoticeBoard/\(i as! String)").observeSingleEvent(of: DataEventType.value) { (snapshot) in
        //note: 가입한 크루의 제목으로 RTDB에서 검색해서 해당 제목의 방에 대한 정보를 불러오는 과정
                
                print("snashot.value의 값은? : \(snapshot.value as! Dictionary<String, Any>)")
                self.signUpCrewInfoDic.append(snapshot.value as! Dictionary<String, Any>)
            }
        }
    }
    
}


    
