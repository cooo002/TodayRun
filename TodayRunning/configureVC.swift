//
//  configureVC.swift
//  TodayRunning
//
//  Created by 김재석 on 04/09/2019.
//  Copyright © 2019 김재석. All rights reserved.
// note:  기본적인 구조는 다 완성함 이제 실제 유저의 회우너 정보 변경 및 로그아웃 기능 그리고 처음 이 VC가 출력될 때 이미지, 이름, 생녕월일, 성별이 보이도록 해주자
//

import Foundation
import Firebase
import UIKit
import SDWebImage


class configureVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var birth: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func logOut(_ sender: Any) {
        //note: 로그아웃을 하는 로직
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "mainStoryBoard")
    
        let firebaseAuth = Auth.auth()//
        do {
            try firebaseAuth.signOut()
            self.appDelegate.userProperty.writeBool(bool: false, key: "signUp")
            self.present(VC, animated: true) {
            print("로그아웃 버트이 탭되고 present 메소드가 실행되었다. ")
            }
          
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    

    func madeImgPickerController(_ source : UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    
    @objc func pickImg(){ // note: 이미지를 탭 하였을 때 실행되는 메소드
        let alert = UIAlertController(title: nil, message: "사진을 가져갈 곳을 선택해주세요", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (UIAlertAction) in
                self.madeImgPickerController(.camera)
            }
            ))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토라이브러리", style: .default, handler: { (UIAlertAction) in
                self.madeImgPickerController(.photoLibrary)
            }))
            
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 사진", style: .default, handler: { (UIAlertAction) in
                self.madeImgPickerController(.savedPhotosAlbum)
            }))
        }
        
        self.present(alert, animated: true)
    }
    

    
    func sendImgStorageOnlyImg( img : UIImage){
        
        let storageRef = Storage.storage().reference()
        var uid =  self.appDelegate.userProperty.readString(key: "uid")
        let spaceRef = storageRef.child("\(uid!)/profile.jpg")
        
        guard let image : UIImage = img else {
            print("이미지 선택 실패!")
            return
        }
        
        let img_data = image.pngData()
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask =  spaceRef.putData(img_data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print("이미지 업로드 도중 에러 발생 : \(error)")
                return
            }
            // You can also access to download URL after upload.
            spaceRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                let urlimg = downloadURL.absoluteString
                self.appDelegate.userProperty.writeString(string: urlimg, key: "img")
                
                print("다운로드 url: \(urlimg)")
                print("프로퍼티에 저장된 다운로드 url: \(self.appDelegate.userProperty.readString(key: "img"))")
                print("에러 없이 프로필 이미지 변경을 위한 이미지 업로드 완료")
                
                
            }
            
        }
    }
    
    
        
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.sendImgStorageOnlyImg(img: img)// note 9/6일 imgSendStorage 클래스를 이용해서 img를 갱신하는 방법!! 일단 이 부붑부터 시작하자!!
        self.profileImg.image = img
        
        picker.dismiss(animated: true)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImg.layer.cornerRadius = self.profileImg.frame.width / 2
      //  self.progfileImg.layer.borderWidth = 0
       // self.progfileImg.layer.masksToBounds = true
        let user = Auth.auth().currentUser
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.profileImg.sd_setImage(with: URL(string: appDelegate.userProperty.readString(key: "img")!))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pickImg))
        self.profileImg.addGestureRecognizer(tap)
        self.profileImg.isUserInteractionEnabled = true
        
        self.name.text = appDelegate.userProperty.readString(key: "name")
        self.birth.text = appDelegate.userProperty.readString(key: "birth")
        self.gender.text = appDelegate.userProperty.readString(key: "gender")
        
        print("프로필 변경 화면을 띄울때 프로퍼티에 저장된 이름의 값은? \(appDelegate.userProperty.readString(key: "name"))")
        print("현재 로그인한 유저의 uid\(user?.uid)")
        
    }
    
    
    
}
