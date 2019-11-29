//
//  AppDelegate.swift
//  TodayRunning
//
//  Created by 김재석 on 01/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
// note: 시작하면서 일단 회원에 대한 데이터를 받아온다??? ( 받아온 후 어디다 저장할 지 가 고민 앱 델리게이트 자체에 저장할 까??)

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import NMapsMap
import XREasyRefresh


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate
{
    var window: UIWindow?
    
    var userProperty =  PropetyList()
    
    var boardInfo = BoardInfo()
    
    var ReloadRTDB = reloadRTDB()
    //note: 구글 로그인을 위한 delegate 메소드
    

    
    var userSignUpCrewList : Array<String> = []
    //ToDo: 현재 유저가 가입한 방에 제목들이 담기는 배열
    
    var crewImgArray : Array<String> = []
    //ToDo: 현재 유저가 가입한 방에 제목들이 담기는 배열
    
    var signUpCrewInfoDic : Array<Dictionary<String, Any>> = [] // note: 현재 로그인한 유저가 가입한 방에 대한 정보가 담기는 Dictionay!!
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        
        print("구글 로그인 메소드 실행! ")
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        if let error = error {
            // ...
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signIn(with: credential) { (user, error) in
            print("auth객체에 정의된 signIn 메소드 실행")
            if let error = error {
                // ...
                return
            }
            // User is signed in

            //           note: 현재 로그인 한 유저의 정보를 읽어오는 부분
            let user = Auth.auth().currentUser
            var gogleloginUid : String?
                if let user = user {
                
                    gogleloginUid = user.uid
                    
                    appDelegate.ReloadRTDB.serchingUserInfoAfterLogIn(gogleloginUid!){
                        self.userProperty.writeBool(bool: true, key: "signUp")
                        self.userProperty.writeString(string: gogleloginUid!, key: "uid")
                        // note: 일단 여기가지는 무리없이 진행됨
                        
                        
                        print("구글 로그인 후 유저의 uid를 이용해서 DB에 저장된 유저의 정보를 가져오는 메소드 실해!")
                        
                        defer{
                            appDelegate.ReloadRTDB.researchingOfSignIn(gogleloginUid!){
                            print("구글 이메일로 로그인 했던적을 확인하고 적절한 뷰로 이동!!")
                            }
                        }
                        
                    }
                //               note: propertyList에 uid가 잘 저장되었는지 확인하는 체크용!!
                    print("현재 로그인한 유저는\(gogleloginUid)")
//                print("저장된 uid\(self.userProperty.readString(key: "uid"))")
                }
        }
    }
    
   
    //note: 구글 로그인을 메소드
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here. 로그아웃 부분??
        
        // ...
    }
    //note: 구글 로그인을 위한 메소드
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    //note: 구글 로그인을 위한 메소드
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {    return GIDSignIn.sharedInstance().handle(url,
                                                                                                                                                                     sourceApplication: sourceApplication,
                                                                                                                                                                     annotation: annotation)
    }
    
    
    
    
    func selectVC(_ signUp : Bool){
        if signUp {
    
                let secondStoryboard = UIStoryboard(name: "Second", bundle: nil)
            // 뷰 컨트롤러 인스턴스
                let viewController = secondStoryboard.instantiateViewController(withIdentifier: "secondStoryBoard")
            
            // 윈도우의 루트 뷰 컨트롤러 설정
                self.window?.rootViewController = viewController
            
                
          
        }
            
        else{ // note: 회원가입을 했던 적인 없는 경우
            let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            // 뷰 컨트롤러 인스턴스
            let viewController = MainStoryboard.instantiateViewController(withIdentifier: "mainStoryBoard")
            
            // 윈도우의 루트 뷰 컨트롤러 설정
            self.window?.rootViewController = viewController
            
        }
        // 이제 화면에 보여주자.
        self.window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = .white //note: 현재 앱 내의 모든 navigation의 색깔을 흰색으로 해주기 위해서 작성함
        self.window = UIWindow(frame: UIScreen.main.bounds)//note: 처음에 시작되는 stroryBoar를 정해주지 않는다면 이렇게 window 객체를 실제로 만들어서 사용해야한다.
        XRRefreshControlSettings.sharedSetting.configSettings(
                  animateTimeForAdjustContentInSetTop: 0.5,
                  animateTimeForEndRefreshContentInSetTop: 0.5,
                  afterDelayTimeForEndInsetTopRefreshing: 0.5,
                  pullLoadingMoreMode: .needPullRelease,
                  refreshStatusLblTextColor: XRRefreshControlSettings.colorFromRGB(hexRGB: 0x333333),
                  refreshStatusLblTextFont: UIFont.systemFont(ofSize: 13))
              
        
        FirebaseApp.configure()
        //note: 구글 로그인을 위한 설정!!
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        //        note: fireBase RTDB에서 데이터를 받아오는 부분 실행!
        Database.database()
        //        note: 회원 가입 여뷰에 따라 청에 실행되는 뷰 컨트롤러를 결정해주는 로직이다
         NMFAuthManager.shared().clientId = "ra3fwyfwi4"// 네이버 맵에 클라이언트 id 등록하는 과정
        
        // Override point for customization after application launch
        //        note: 시작하면서 일단 fireBase에서 데이터를 땡겨오자!!!
        print("didFinishLaunckingWithOptions 메소드 시작!!")
        print("앱 실해하면서 로그인된 유저의 uid\(self.userProperty.readString(key: "uid"))")

        // window가 없으니 만들어준다.
        
//        self.userProperty.writeBool(bool: false, key: "signUP")// note: 강제적으로 second story를 실행하도록 해주는 코드
        var checkingStory = self.userProperty.readBool(key: "signUP")
        
       
        
    
        
        
        // check!: 구글 로그인 버튼을 누르면 분명 sign은 true로 바뀌어야하는데 왜 안 바껴...(프로퍼티 리스트 구조체를 만들어서 다뤄보자)
//        self.plist.set(false, forKey: "signUp")
//        self.plist.synchronize()
        //note : 도대체 왜 메인 스토리 보드로 넘어가고 나서야 noticeInfoReload이 실행되는가??
        DispatchQueue.global().sync {
            self.ReloadRTDB.initNoticeInfoReload(nil){
//                 self.userProperty.writeBool(bool: false, key: "signUP")// note: 강제적으로 second story를 실행하도록 해주는 코드
//           /     var signUp =  self.userProperty.readBool(key: "signUp")
                if checkingStory {
                    
                    let secondStoryboard = UIStoryboard(name: "Second", bundle: nil)
                    // 뷰 컨트롤러 인스턴스
                    let viewController = secondStoryboard.instantiateViewController(withIdentifier: "secondStoryBoard")
                    
                    
//                    self.ReloadRTDB.signUpCrewJudgeMent()
                    
                    // 윈도우의 루트 뷰 컨트롤러 설정
                    self.window?.rootViewController = viewController
                    
                    
                    
                }
                    
                else{ // note: 회원가입을 했던 적인 없는 경우
                    let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    // 뷰 컨트롤러 인스턴스
                    let viewController = MainStoryboard.instantiateViewController(withIdentifier: "mainStoryBoard")
                    
                    // 윈도우의 루트 뷰 컨트롤러 설정
                    self.window?.rootViewController = viewController
                    
                }
                // 이제 화면에 보여주자.
                
                self.window?.makeKeyAndVisible()
            }
        // note: 추천 스팟에 대한 정보를 불러오는 메소드이다
            self.ReloadRTDB.recommendSpotReload(){
                print("추천스팟에 대한 데이터를 RTDB에서 전부 불러왔다")
            }
                //note : 공공 데이터 포털에서 받아온 데이터를 저장한 RTDB에서 데이터를 불러오는 로직이다.
            self.ReloadRTDB.reloadOpenAPIData()
            self.ReloadRTDB.signUpCrewJudgeMent()
        }
//        self.selectVC(checkingStory)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TodayRunning")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

