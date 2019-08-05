//
//  MessageModel.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/4.
//  Copyright © 2019 louyu. All rights reserved.
//

import Foundation

struct MessageModel {
    let message: String
    let senderUsername: String
    let messageSender: MessageSender
    
    init(message: String, messageSender: MessageSender, username: String) {
        self.message = message.withoutWhitespace()
        self.messageSender = messageSender
        self.senderUsername = username
    }
}

enum MessageSender {
    case ourself
    case someoneElse
}
