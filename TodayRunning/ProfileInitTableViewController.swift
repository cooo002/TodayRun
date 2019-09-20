//
//  ProfileInitTableViewController.swift
//  TodayRunning
//
//  Created by 김재석 on 06/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//note:  처음 기본 뼈대는 tavleViewController로 하고 거기 상단에 view를 추가하여 구성한 뷰 컨트롤러이다 

import Foundation
import UIKit

//note: 프로필 사진을 클릭하였을 때 이미지 피커 컨트롤러가 실행되도록 하기위해 프로토콜을 추가함
//extension ProfileInitViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
//
//

class ProfileInitTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    let profileImage = UIImageView()
    var imgsendStorage : imgSendStorage? //note: 이미지를 스토리지에 전송하는 클래스
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
 
    @IBOutlet weak var text: UITextField!
    

    @IBOutlet weak var date: UILabel!//note: 셀을 클릭하면 actionSheet에 datePicker가 추가되어 창이 뜨고 거기서 날짜를 선택하는 방향을 로직을 짜자
    
    @IBOutlet weak var gender: UISegmentedControl!
    

    
    @objc func sendData(_ send : Any){
        
 
        
        //       note: fireBase에 데이터를 보내는 로직을 작성하자
         self.appDelegate.userProperty.writeBool(bool: true, key: "signUp")
        var secondStory = UIStoryboard(name: "Second", bundle: nil)
        var viewController = secondStory.instantiateViewController(withIdentifier: "secondStoryBoard")
        
        
        var name = self.text.text as String?
        var birth = self.date.text as String?
        var gender = self.genderReturn(gender: self.gender.selectedSegmentIndex )//note: 이 부분에서 함수 하나 만들어서 조건문 따라 설명을 반환해주게  return 으로 반환해주자!!!
        var img = self.profileImage.image!
        
        imgsendStorage = imgSendStorage(name: name!, gender: gender, birth: birth!)
        imgsendStorage!.sendImgStorage(img: img)
        
        self.present(viewController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            // note: 생년월일을 설정하는 셀이 클릭 선택되었을 때 date를 설정하는 actionSheet를 띄워주자!!
            print("생년월일 셀이 선택됨")
           self.alertDatePicker(label: date)
        }
        else{//note: 생년월일 셀이 아님 다른 셀이 선택 되었을때는 그냥 넘겨버린다
            return ()
        }
    }
    
    func genderReturn( gender: Int) -> String{
        if gender == 0 {
            return "남"
        }
        else{
            return "여"
        }
        
    }
    
    func alertDatePicker( label : UILabel){
        let datePicker = UIDatePicker()//note: picker를 date 타입으로 바꾸고 한국어로 설정을 바꿔주자
        datePicker.datePickerMode = .date
        datePicker.locale =  NSLocale(localeIdentifier: "ko_KO") as Locale // datePicker의 디폴트 값은 영어이기 때무에 한글로 바꿔줘야한다. 그래서 이렇게 바꿔주는 것이다 .
        
        let dateChooserAlert = UIAlertController(title: "생년월일을 선택..", message: nil, preferredStyle: .actionSheet)
        
        dateChooserAlert.view.addSubview(datePicker)
        dateChooserAlert.addAction(UIAlertAction(title: "선택완료", style: .cancel, handler: { action in
            // Your actions here if "Done" clicked...
            let date = self.dateFormat(datePicker: datePicker) //note: datePicker를 통해 설정한 date값을 string으로 바꿨다
            print("date값은 : \(date)")
            label.text = date
        }))
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooserAlert.view.addConstraint(height)
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    
    func dateFormat( datePicker: UIDatePicker) -> String{ //note: 데이트 피커에서 선태될 생년월일을 string 타입으로 변환해주는 메소드(yyyy-MM-dd 타입으로 변환해줌)
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = .short
        
        dateformatter.timeStyle = .none
        dateformatter.dateFormat = "yyyy-MM-dd";
        
        let date = dateformatter.string(from: datePicker.date )
        
        return date
    }
     //    note: 이미지 피커를 이용해서 사진을 선택하면 자동으로 실행되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("사진 선택 완료\(info[UIImagePickerController.InfoKey.editedImage])")
        var img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.profileImage.image = img
        picker.dismiss(animated: true, completion: nil)
    }
    //   note: 전달받은 source 타입의 따른 이미지 피커를 실행 해주는 메소드 
    func imgPicker(_ source : UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true )
        
    }
    
    
    
    @objc func pickerAlert(_: Any){
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택하세요", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default){ (_) in
                self.imgPicker(.camera)
                
            })
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default){ (_) in
                self.imgPicker(.photoLibrary)
                    
            })
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 사진", style: .default){ (_) in
                self.imgPicker(.savedPhotosAlbum)
                        
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "프로필"
        let sendDataBtn = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(sendData(_:)))
        self.navigationItem.rightBarButtonItem = sendDataBtn
        
        //note: 프로필 이미지 뷰룰 추가하는 로직 나중에 이것도 따로 함수 하나를 만들어주자!!
        let img = UIImage(named: "account.jpg")
        
        self.profileImage.image = img
        self.profileImage.frame.size = CGSize(width: 100, height: 100 )
        self.profileImage.center = CGPoint(x: self.view.frame.width/2, y: 70)
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = 0
        self.profileImage.layer.masksToBounds = true
        
        self.view.addSubview(profileImage)
        
        //        note: imageview에 제스쳐를 추가해준다.
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerAlert(_:)))
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.isUserInteractionEnabled = true // uicontrol을 상속 받지 않는 객체는 기본적으로 사용자의 반응하지 않도록 하기위해 이 속성이 false로 되어있다
        
        
    }

}


