//
//  GetContactsNetworking.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/4.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation
import Moya

public enum Contacts {
    case getContacts
}

extension Contacts: TargetType{
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
        return .requestData(jsonToData(jsonDic: ["type": "contact", "account": currentUser.logUserName])!)
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}

