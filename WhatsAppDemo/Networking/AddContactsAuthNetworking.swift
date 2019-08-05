//
//  AddContactsAuthNetworking.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/5.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation
import Moya

public enum AddContacts {
    case addContact(sendUser: String)
}

extension AddContacts: TargetType{
    public var baseURL: URL {
        return URL(string: "http://35.228.196.231:8080")!
    }
    
    public var path: String {
        return "/web/html"
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case let .addContact(sendUser):
            return .requestData(jsonToData(jsonDic: ["type": "addcontact", "account": currentUser.logUserName,"senduser":sendUser])!)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}
