//
//  logInVC.swift
//  TodayRunning
//
//  Created by 김재석 on 26/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
// ToDo: 이메일 회원가입을 하고 이메일 로그인을 하는 VC이다.


import Foundation
import UIKit
import Firebase
import FCAlertView

class  logInVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var window : UIWindow?
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var logInButtonText: UIButton!
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        //note: email회원가입을 수행하는 액션 메소드
         if let email = email.text, let pass = passWord.text{
                    
                    Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                        // ...
        //
                        let newUser = authResult?.user.uid
                        print("email을 이용한 회원가입을 하고 그 결과 파베롤 부터 얻은  uid는 ?: \(newUser) ")
                        let user = Auth.auth().currentUser
                        var emailloginUid : String?
                        if let user = user {
                            // The user's ID, unique to the Firebase project.
                            // Do NOT use this value to authenticate with your backend server,
                            // if you have one. Use getTokenWithCompletion:completion: instead.
                            emailloginUid = user.uid
                            //               note: propertyList에 uid가 잘 저장되었는지 확인하는 체크용!!
                            print("현재 로그인한 유저는\(emailloginUid)")
                            //                print("저장된 uid\(self.userProperty.readString(key: "uid"))")
                            self.appDelegate.userProperty.writeBool(bool: true, key: "signUP")
                            self.appDelegate.userProperty.writeString(string: emailloginUid!, key: "uid")
                            print("email로 회원가입한 유저의 uid와 현재 회원가입 상태는?: \(self.appDelegate.userProperty.readBool(key: "signUP")),\( self.appDelegate.userProperty.readString(key: "uid"))")
                        }
                    }
             self.signAlert()
                }
         else{
                print("로그인 실패!!")
                self.emptyAlert()

            
        }
       
    }
    
    
    
    @IBAction func signIn(_ sender: Any) {
        //note: email 로그인하는 액션이다!!!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         if let email = email.text, let pass = passWord.text{
            print("email로그인을 진행하는 첫번째 if 문 들어감 ")
            if (email != ""), (pass != ""){
                print("email 로그인을 진행하고 이메일과 비번을 입력했는지 확인하는 if문 들어감!")
        
                Auth.auth().signIn(withEmail: email, password: pass) { [weak self] user, error in
                    print("파베에서 제공하는 email 로그인 메소드가 실행됨")
                     guard let strongSelf = self else {
                        //로그인이 실행되지 않았을 경우 실행되는 부분
                        print("파베에서 제공하는 email 로그인 메소드가 실행되지 않았다!!! ")
                        self?.emailLoginFalseAlert()
                        return
                        
                    }
                    
                    print("email로그인 메소드 실행시 상수 strongSelf에 저장된 값은?? : \(strongSelf)")
                     print("email로그인 메소드 실행시 상수 클로져 파라미터인 user에 저장된 값은?? : \(user)")
//                    let user = Auth.auth().currentUser // 이 부분에서 현재 로그인한 유저의 정보를 못 받아오는거 같아!!!
                     
                    var emailloginUid : String?
                    //도대체 왜 이 조건문으로 안들어가지?? 분명히 조거네 맞는데...
                    if let user = user?.user {
                            print("파베에서 제공하는 email 로그인 메소드가 실행되고 현재 로그인 잘되서 로그인한 유저의 정보를 읽어오고 확인하는 if 문이 실행됨!!")
                                // The user's ID, unique to the Firebase project.
                                // Do NOT use this value to authenticate with your backend server,
                                // if you have one. Use getTokenWithCompletion:completion: instead.
                            emailloginUid = user.uid
                        //               note: propertyList에 uid가 잘 저장되었는지 확인하는 체크용!!
                            print("현재 로그인한 유저는\(emailloginUid)")
                        //                print("저장된 uid\(self.userProperty.readString(key: "uid"))")
                            appDelegate.userProperty.writeBool(bool: true, key: "signUP")
                            appDelegate.userProperty.writeString(string: emailloginUid!, key: "uid")
                            print("email로 회원가입한 유저가 로그인 버튼을 탭 했을 때 현재 회원가입 상태는?: \(appDelegate.userProperty.readBool(key: "signUP")),\( appDelegate.userProperty.readString(key: "uid"))", "\(appDelegate.userProperty.readString(key: "img"))" )
                            //note: 여기서 유저 정볼르 검핵하는 메소드를 이용해서 로인한 유저의 메소드를 잧아와서 propertyㅣist에 저장하자
                            self?.appDelegate.ReloadRTDB.serchingUserInfoAfterLogIn(emailloginUid!){
                                print("properyList 저장을 위해서 로그인한 우저의 uid를 넘김")
                            }
                              self!.signInFinishAlert()
                    }
                  
            }
            }
                else{
                    self.emptyAlert()
            }
    }
         else{
            //note:각 항목을 체우지 않은 경우에 alert창을 띄우자!!
             print("로그인 실패!!")
            
        }
    }
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }



    
    func signAlert(){
        
        var alert = FCAlertView()
                
        //        alert.delegate = self
                alert.makeAlertTypeSuccess()
                alert.colorScheme = .gray
                alert.firstButtonTitleColor = .white
                alert.firstButtonBackgroundColor = .gray
                
                alert.addButton("확인") {
                    print("회원 가입 후 확인 버튼 클릭")
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = mainStoryBoard.instantiateViewController(withIdentifier: "_ProfileInit2")
                    self.present(mainViewController, animated: true)
                }
        
                alert.hideDoneButton = true

                alert.showAlert(inView: self,
                                withTitle: "회원가입 완료!!",
                                withSubtitle: "화원 가입이 완료 되었습니다. 이후 진행을 원하시면 아래 버튼을 탭하세요!!",
                                withCustomImage: nil,
                                withDoneButtonTitle: nil,
                                andButtons: nil)
                 }
    
    
    
    func signInFinishAlert(){
        
        
            var alert = FCAlertView()
                    
            //        alert.delegate = self
                    alert.makeAlertTypeSuccess()
                    alert.colorScheme = .gray
                    alert.firstButtonTitleColor = .white
                    alert.firstButtonBackgroundColor = .gray
                    
                    alert.addButton("확인") {
                        print("로그인 후 확인 버튼 클릭")
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let mainStoryBoard = UIStoryboard(name: "Second", bundle: nil)
                        let profileInitNavigationVC = mainStoryBoard.instantiateViewController(withIdentifier: "secondStoryBoard")
                        self.window?.rootViewController = profileInitNavigationVC
                        self.window?.makeKeyAndVisible()
                       
                    }
            
                    alert.hideDoneButton = true

                    alert.showAlert(inView: self,
                                    withTitle: "로그인 완료!",
                                    withSubtitle: nil,
                                    withCustomImage: nil,
                                    withDoneButtonTitle: nil,
                                    andButtons: nil)
                  }
    
    func emptyAlert(){
        
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
    
    
    func emailLoginFalseAlert(){
        
        var alert = FCAlertView()
                
        //        alert.delegate = self
                alert.makeAlertTypeWarning()
                alert.colorScheme = .gray
                alert.firstButtonTitleColor = .white
                alert.firstButtonBackgroundColor = .gray
                
                alert.addButton("확인") {
                    print("email 로그인 실패용  경고창이 나오고 확인 버튼 클릭")
                   
                }
        
                alert.hideDoneButton = true

                alert.showAlert(inView: self,
                                withTitle: nil,
                                withSubtitle: "email 로그인이 실패하였습니다!!",
                                withCustomImage: nil,
                                withDoneButtonTitle: nil,
                                andButtons: nil)

        
    }
    
    
   

    override func viewDidLoad() {
            super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    
        
            }
            
}
