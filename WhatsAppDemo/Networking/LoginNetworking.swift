//
//  LoginNetworking.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/1.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation
import Moya


public enum Login {
    case pushLogMessage(account: String, password : String)
    case test
}

extension Login: TargetType{
    public var baseURL: URL {
        return URL(string: "http://35.228.196.231:8080")!
    }
    
    public var path: String {
        switch self {
        case .test:
            return "/JavaW/html"
        case .pushLogMessage( _, _):
            return "/web/html"
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .pushLogMessage( _, _):
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
        case let .pushLogMessage(account, password):
            return .requestData(jsonToData(jsonDic: ["type": "login","account":account,"password":password])!)
        case .test:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}
