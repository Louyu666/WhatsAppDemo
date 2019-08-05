//
//  ChatButtomView.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/3.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit
import SnapKit

class ChatButtomView: UIView {
    
    let messageTextView = UITextView()
    let sendBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        setViews()
    }
    
    func setViews() {
        self.addSubview(messageTextView)
        self.addSubview(sendBtn)
        
        self.sendBtn.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.right.equalTo(-10)
            make.top.equalTo(5)
            make.bottom.equalTo(-30)
            self.sendBtn.setTitle("Send", for: .normal)
            self.sendBtn.backgroundColor = UIColor(red: 8/255, green: 183/255, blue: 231/255, alpha: 1.0)
            self.sendBtn.layer.cornerRadius = 4
            self.sendBtn.clipsToBounds = true
        }
        
        self.messageTextView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.equalTo(40)
            make.top.equalTo(5)
            make.bottom.equalTo(-30)
            make.right.equalTo(sendBtn.snp.left).offset(-5)
            self.messageTextView.layer.cornerRadius = 4
            self.messageTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.6).cgColor
            self.messageTextView.layer.borderWidth = 1
            self.messageTextView.isScrollEnabled = true
            self.messageTextView.clipsToBounds = true
            self.messageTextView.font = UIFont.systemFont(ofSize: 18)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
