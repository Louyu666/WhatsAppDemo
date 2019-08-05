//
//  UserModel.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/7/31.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation

struct UserModel {
    var logUserName: String
    var contact: [String]
    var megList: [String]
    
    init(logUserName: String) {
        self.logUserName = logUserName
        self.contact = []
        self.megList = []
    }
}
