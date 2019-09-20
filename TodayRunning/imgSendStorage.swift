//
//  imgSendStorage.swift
//  TodayRunning
//
//  Created by 김재석 on 12/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//
//
import Foundation
import Firebase

class imgSendStorage{
    
    
    let storageRef = Storage.storage().reference()
    var Userproperty = PropetyList()//개인 정보가 저장된 propertyList 객체를 생성한다.
    var datasendStorage : dataSendFireBase?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var img : String?
    var uid : String?
    var urlimg : String?
    var name : String?
    var gender: String?
    var birth : String?
    
    
    init(name : String , gender: String, birth : String) {
        
        self.name = name
        self.gender = gender
        self.birth = birth
        
        self.appDelegate.userProperty.writeString(string: self.birth!, key: "birth")
          self.appDelegate.userProperty.writeString(string: self.name!, key: "name")
           self.appDelegate.userProperty.writeString(string: self.gender!, key: "gender")
    }
    
    func sendImgStorage( img : UIImage){
        
        var uid =  self.appDelegate.userProperty.readString(key: "uid")
        let spaceRef = self.storageRef.child("\(uid!)/profile.jpg")
        
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
               self.urlimg = downloadURL.absoluteString
                self.appDelegate.userProperty.writeString(string: self.urlimg!, key: "img")
             
                print("다운로드 url: \(self.urlimg)")
                print("프로퍼티에 저장된 다운로드 url: \(self.Userproperty.readString(key: "img"))")
                print("에러 없이 이미지 업로드 완료")
                self.datasendStorage = dataSendFireBase(name : self.name!, gender: self.gender!, birth : self.birth!)
                self.datasendStorage!.sendDataRTDB()
                
            }
            
        }
    }


func sendImgStorageOnlyImg( img : UIImage){
    
    var uid =  self.appDelegate.userProperty.readString(key: "uid")
    let spaceRef = self.storageRef.child("\(uid!)/profile.jpg")
    
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
            self.urlimg = downloadURL.absoluteString
            self.appDelegate.userProperty.writeString(string: self.urlimg!, key: "img")
            
            print("다운로드 url: \(self.urlimg)")
            print("프로퍼티에 저장된 다운로드 url: \(self.Userproperty.readString(key: "img"))")
            print("에러 없이 프로필 이미지 변경을 위한 이미지 업로드 완료")
        
            
        }
        
    }
}
}
