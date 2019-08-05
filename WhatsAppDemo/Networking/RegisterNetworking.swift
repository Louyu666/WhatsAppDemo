//
//  RegisterNetworking.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/4.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation
import Moya


public enum Register {
    case pushRegMessage(account: String, password : String)
    case test
}

extension Register: TargetType{
    public var baseURL: URL {
        return URL(string: "http://35.228.196.231:8080")!
    }
    
    public var path: String {
        switch self {
        case .test:
            return "/JavaW/html"
        case .pushRegMessage( _, _):
            return "/web/html"
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .pushRegMessage( _, _):
            return .post
        case .test:
            return .get
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case let .pushRegMessage(account, password):
            return .requestData(jsonToData(jsonDic: ["type": "register","account":account,"password":password])!)
        case .test:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}
