//
//  signViewController.swift
//  TodayRunning
//
//  Created by 김재석 on 03/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//note: 로그인을 담당하는 뷰컨트롤러이다 !!
//note: 구글 로그인 버튼을 클리하면 실행되는 sign 메소드는 델리게이트 설정을 한 appDelegate클래스에 정의된 sign메소드가 실행되는 것이다



import Foundation
import UIKit
import Firebase
import GoogleSignIn
import LGButton




class signViewController:UIViewController, GIDSignInUIDelegate{
    
    @IBOutlet weak var bgView: UIImageView!
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    
    @IBAction func moveLogInView(_ sender: Any) {

        var celyStoryBoard = UIStoryboard(name: "Cely", bundle: nil)
                      var celyviewController = celyStoryBoard.instantiateViewController(withIdentifier: "logInStoryBoard")
              self.navigationController?.show(celyviewController, sender: true)
              
        
    }
    
   
    @IBAction func moveSignUpView(_ sender: Any) {
    
    
         var celyStoryBoard = UIStoryboard(name: "Cely", bundle: nil)
                var celyviewController = celyStoryBoard.instantiateViewController(withIdentifier: "logInStoryBoard")
        self.navigationController?.show(celyviewController, sender: true)
        
        
    }

        override func viewDidLoad() {
        super.viewDidLoad()
            
//            GIDSignIn.sharedInstance()?.presentingViewController = self 
            
//            GIDSignIn.sharedInstance().signIn() 
            
            self.googleLoginButton.layer.cornerRadius = self.googleLoginButton.bounds.width / 12
            self.googleLoginButton.layer.borderWidth = 0
            self.googleLoginButton.layer.masksToBounds = true

            self.navigationController?.isNavigationBarHidden = true // note: 네비게이션 바를 감추는 것이다.
         GIDSignIn.sharedInstance().uiDelegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

       
        var check = appDelegate.userProperty.readBool(key: "signUp")
        print("회원가입여부??",check)
        var currentUser = Auth.auth().currentUser?.email
            print("현재 로그인 되어있는 유저의 이메일은? : \(currentUser)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        
        
        
    }
}
