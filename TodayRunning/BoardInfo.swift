//
//  BoardInfo.swift
//  TodayRunning
//
//  Created by 김재석 on 17/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//note:  공지를 개설하고 그 데이터가 RTDB에 올라가지 전에 잠시 저장되는 곳, 이것을 AppDelegate 클래스 하나에만 만들어두고 싱글톤 패턴으로 구현하여 사용할 것이다 .
// note: 출발지, 도착지 위경도를 딕셔너리 형태로 저장??

import Foundation

struct BoardInfo {
//    var title : String?
//    var numOfPeople : String?
//    var notice : String?
    var departureLat : Double?//note: 일단 string으로 해놨는데 latlang의 데이터 타입을 보고 고치자!
    var departureLng : Double?
    var destinationLat : Double?
    var destinationLng : Double?
    var location: String?
    var attempPersonArr : Array<String>? // note: 참여하는 인원에 이름이 들어가는 배열이다 .
    
}
//
//struct BoardInfo {
//    var title : String?
//    var numOfPeople : String?
//    var notice : String?
//    var departureLatlng : String? //note: 일단 string으로 해놨는데 latlang의 데이터 타입을 보고 고치자!
//    var destinationLatlng : String?  //note: 일단 string으로 해놨는데 latlang의 데이터 타입을 보고 고치자!
//    
//}

