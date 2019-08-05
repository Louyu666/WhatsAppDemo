//
//  MessageNetworking.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/3.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation
import Moya


public enum Message {
    case getMsg
    case postMsg(sendUser: String, content: String)
}

extension Message: TargetType{
    public var baseURL: URL {
        return URL(string: "http://35.228.196.231:8080")!
    }
    
    public var path: String {
        switch self {
        case .getMsg:
            return "/web/html"
        case .postMsg(_,_):
            return "/web/html"
        }
        
    }
    
    public var method: Moya.Method {
        switch self {
        case .getMsg:
            return .post
        case .postMsg(_,_):
            return .post
        }
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .getMsg:
            return .requestData(jsonToData(jsonDic: ["type": "receivemsg", "account": currentUser.logUserName])!)
        case let .postMsg(sendUser, content):
            return .requestData(jsonToData(jsonDic: ["type": "sendmsg","account": currentUser.logUserName, "senduser": sendUser, "content": content])!)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}
