//
//  collectinOfCrewPhotoVC.swift
//  TodayRunning
//
//  Created by 김재석 on 2019/11/24.
//  Copyright © 2019 김재석. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Foundation

//var reuseIdentifier = "photoCollectionCell"

class collectinOfCrewPhotoVC: UICollectionViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var crewTitle : String?
    
    
    func madeImgPickerController(_ source: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func selectedPicture(_ sender: UIBarButtonItem) {
        print("사진 선택 탭하기!!")
        let alert = UIAlertController(title: nil, message: "사진을 가저올 곳을 선택해주세요!", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (UIAlertAction) in
                self.madeImgPickerController(.camera)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (UIAlertAction) in
                self.madeImgPickerController(.photoLibrary)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 사진", style: .default, handler: { (UIAlertAction) in
                self.madeImgPickerController(.savedPhotosAlbum)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendImgStorageOnlyImg( img : UIImage){
          
          var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var date = self.dateReturn()
          let storageRef = Storage.storage().reference()
          var uid =  appDelegate.userProperty.readString(key: "uid")
        let spaceRef = storageRef.child("crewInfo").child("\(self.crewTitle!)").child("\(date).jpg")
//        child("crewInfo/\(self.crewTitle!)/\(date).jpg").
          
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
                // urlimg를 매개변수로 날리고 그것을이용해서 RTDB애 올리기
                appDelegate.crewImgArray.append(urlimg)// 방금 올린 사진의 url을 배열에 추가시켜준다.
                
                
                  //check 여기서 방별로 RTDB에 저장되도록 만들어주자!
//                  self.appDelegate.userProperty.writeString(string: urlimg, key: "img")
                  //check: 회원정보 DB에 변경된 사진의 url이 갱신 안되는거 같은데??
                  //check: 다운로드 url을 받아오고 그것을 RTDB에 어떻게 저장할 지 부터 시작하자!!!!
//                self.sendImgRTDB(imgUrl: urlimg)
                self.sendImgRTDB(imgUrlArray: appDelegate.crewImgArray)
                print("다운로드 url: \(urlimg)")
//                  print("프로퍼티에 저장된 다운로드 url: \(self.appDelegate.userProperty.readString(key: "img"))")
                print("에러 없이 프로필 이미지 변경을 위한 이미지 업로드 완료")
                  
                  
              }
              
          }
      }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //ToDo: 이미지 선택이 완료되었을 때 실행되는 메소드이다.!!
        
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        var img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.sendImgStorageOnlyImg(img: img)// note 9/6일 imgSendStorage 클래스를 이용해서 img를 갱신하는 방법!! 일단 이 부붑부터 시작하자!!
//check: 바로 활동사진 셀에 적용하도록 해주자!!
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func dateReturn() -> String{
        //ToDo: 현재 시간 날짜를 반환해주는 메소드
        
        let date = Date() // --- 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" // --- 2
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
//        let nib = UINib(nibName: "yourItemView", bundle: nil)
//        collectionView.registerNib(nib, forCellWithReuseIdentifier: "yourItemView")
//
        self.collectionView.register(UINib(nibName:crewPhotoCollectionViewCell.reuseableIdentifier , bundle: nil), forCellWithReuseIdentifier: crewPhotoCollectionViewCell.reuseableIdentifier)
        //ToDo: 콜렉션 뷰 셀을 등록하는 메소드이다.
        
        // Register cell classes
//        self.collectionView!.register(crewPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
       //self.register(crewPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.crewImgArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     //   var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! crewPhotoCollectionViewCell
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: crewPhotoCollectionViewCell.reuseableIdentifier, for: indexPath) as! crewPhotoCollectionViewCell
        cell.crewImg.sd_setImage(with: URL(string:  appDelegate.crewImgArray[indexPath.row] as! String))
        //여기서 셀에 활동 이미지 적용시켜주자!!
        
        // Configure the cell
//        cell.contentView.frame.size.width = 100
//        cell.contentView.frame.size.height = 200
        
        
        
    
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 105, height: 105)

        }

        

        //위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            return 6

        }

        //좌우간격

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

            return 1

        }
    
    func sendImgRTDB(imgUrlArray: Array<String>){
                //        note: PropertyList에 저장된 모든 정보를 uid에 따라 저장하면된다.
        var appDelegate =  UIApplication.shared.delegate as! AppDelegate
        var ref = Database.database().reference()
                
        ref.child("ios/runnigNoticeBoard/\(crewTitle!)/ActivityImgUrl").setValue(imgUrlArray as! Array<String>)
             //check: 방이름으로 db가 저장되도록 만들어주자!!1
                
        print("db로 데이터 업로드 완료!!")
                
            }






    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
