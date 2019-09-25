//
//  SignUpViewController.swift
//  TodayRunning
//
//  Created by 김재석 on 06/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var pass: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        if let email = email.text, let pass = pass.text{
            
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
        }
        self.signAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func signAlert(){
        let alert = UIAlertController(title: "회원가입 완료", message: "축하합니다 회원가입 왼료되었습니다!! 다음 진행을 원하시면 확인 버튼을 눌러주시기 바랍니다^^", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default){ (action) in
            let profileInitNavigationVC = self.storyboard?.instantiateViewController(withIdentifier: "_ProfileInit2")
            self.present(profileInitNavigationVC!, animated: true)
            
        }
        alert.addAction(alertAction) // note: 여기 확인 버튼을 누르고 난 다음에 프로필 작성 페이지가 실행되도록 로직은 짜자!!
        present(alert, animated: true)
        
        }

    }

