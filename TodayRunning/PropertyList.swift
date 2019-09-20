//
//  PropertyList.swift
//  TodayRunning
//
//  Created by 김재석 on 08/08/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation

class PropetyList {
    
    var plist = UserDefaults.standard
    var userStruct = UserStruct()
    
    
    func writeBool(bool: Bool, key: String){
        self.plist.set(bool, forKey: key)
        self.plist.synchronize()

        
    }

    func writeString(string: String, key: String){
        self.plist.set(string, forKey: key)
        self.plist.synchronize()
        self.userStruct.name = string

        
    }
    
    func readString(key: String) -> String?{
        var stringVal = self.plist.string(forKey: key)
        return stringVal
        
    }
    
    func readBool(key: String)-> Bool{
        var boolVal = self.plist.bool(forKey: key)
          return boolVal
        
    }
    
}
