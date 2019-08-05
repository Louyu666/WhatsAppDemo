//
//  ChatMessageTableViewCell.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/4.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {

    var messageSender: MessageSender = .ourself
    let messageLabel = MessageLabel()
    let nameLabel = UILabel()
    
    func apply(message: MessageModel) {
        nameLabel.text = message.senderUsername
        messageLabel.text = message.message
        messageSender = message.messageSender
        setNeedsLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.clipsToBounds = true
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        
        clipsToBounds = true
        
        addSubview(messageLabel)
        addSubview(nameLabel)
    }

    
    class func height(for message: MessageModel) -> CGFloat {
        let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
        let nameHeight = message.messageSender == .ourself ? 0 : (height(forText: message.senderUsername, fontSize: 10, maxSize: maxSize) + 4 )
        let messageHeight = height(forText: message.message, fontSize: 17, maxSize: maxSize)
        
        return nameHeight + messageHeight + 32 + 16
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatMessageTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        if isJoinMessage() {
//            layoutForJoinMessage()
//        } else {
            messageLabel.font = UIFont.systemFont(ofSize: 17)
            messageLabel.textColor = .white
            
            let size = messageLabel.sizeThatFits(CGSize(width: 2*(bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude))
            messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
            
            if messageSender == .ourself {
                nameLabel.isHidden = true
                
                messageLabel.center = CGPoint(x: bounds.size.width - messageLabel.bounds.size.width/2.0 - 16, y: bounds.size.height/2.0)
                messageLabel.backgroundColor = UIColor(red: 24/255, green: 180/255, blue: 128/255, alpha: 1.0)
            } else {
                nameLabel.isHidden = true
                nameLabel.sizeToFit()
                nameLabel.center = CGPoint(x: nameLabel.bounds.size.width/2.0 + 16 + 4, y: nameLabel.bounds.size.height/2.0 + 4)
                
                messageLabel.center = CGPoint(x: messageLabel.bounds.size.width/2.0 + 16, y: messageLabel.bounds.size.height/2.0 + nameLabel.bounds.size.height + 8)
                messageLabel.backgroundColor = .lightGray
            }
//        }
        
        messageLabel.layer.cornerRadius = min(messageLabel.bounds.size.height/2.0, 20)
    }
    
//    func layoutForJoinMessage() {
//        messageLabel.font = UIFont.systemFont(ofSize: 10)
//        messageLabel.textColor = .lightGray
//        messageLabel.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
//
//        let size = messageLabel.sizeThatFits(CGSize(width: 2*(bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude))
//        messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
//        messageLabel.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2.0)
//    }
//
//    func isJoinMessage() -> Bool {
//        if let words = messageLabel.text?.components(separatedBy: " ") {
//            if words.count >= 2 && words[words.count - 2] == "has" && words[words.count - 1] == "joined" {
//                return true
//            }
//        }
//
//        return false
//    }
}

