//
//  logInVC.swift
//  TodayRunning
//
//  Created by 김재석 on 26/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

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
         if let email = email.text, let pass = passWord.text{
                    
                    Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                        // ...
        //
        //                let newUser = authResult?.user.
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         if let email = email.text, let pass = passWord.text{
            
            if (email != ""), (pass != ""){
        
                Auth.auth().signIn(withEmail: email, password: pass) { [weak self] user, error in
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
                            appDelegate.userProperty.writeBool(bool: true, key: "signUP")
                            appDelegate.userProperty.writeString(string: emailloginUid!, key: "uid")
                            print("email로 회원가입한 유저의 uid와 현재 회원가입 상태는?: \(appDelegate.userProperty.readBool(key: "signUP")),\( appDelegate.userProperty.readString(key: "uid"))")
                            //note: 여기서 유저 정볼르 검핵하는 메소드를 이용해서 로인한 유저의 메소드를 잧아와서 propertyㅣist에 저장하자
                            self?.appDelegate.ReloadRTDB.serchingUserInfoAfterLogIn(emailloginUid! ){
                                print("properyList 저장을 위해서 로그인한 우저의 uid를 넘김")
                            }
                    }
                    self!.signInFinishAlert()
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
    
   

    override func viewDidLoad() {
            super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    
        
            }
            
}
