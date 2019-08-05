//
//  Global.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/7/31.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation
import UIKit

let topBarHeight = UINavigationController().navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height
let tabBarHeight = UITabBarController().tabBar.frame.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

func jsonToData(jsonDic:Dictionary<String, Any>) -> Data? {
    if (!JSONSerialization.isValidJSONObject(jsonDic)) {
        print("is not a valid json object")
        return nil
    }
    //利用自带的json库转换成Data
    //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
    //Data转换成String打印输出
    let str = String(data:data!, encoding: String.Encoding.utf8)
    //输出json字符串
    print("Json Str:\(str!)")
    return data
}
