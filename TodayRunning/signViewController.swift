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



class signViewController:UIViewController, GIDSignInUIDelegate{

    
        override func viewDidLoad() {
        super.viewDidLoad()
         GIDSignIn.sharedInstance().uiDelegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

       
        var check = appDelegate.userProperty.readBool(key: "signUp")
        print("회원가입여부??",check)
        var currentUser = Auth.auth().currentUser?.email
            print("현재 로그인 되어있는 유저의 이메일은? : \(currentUser)")
            
        
        
        
        
    }
    
}
