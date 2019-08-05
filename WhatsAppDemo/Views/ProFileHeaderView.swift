//
//  ProFileHeaderView.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/3.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit

class ProFileHeaderView: UIView {
    
    let avatarImageView = UIImageView(image: UIImage(named: "default-profilephoto"))
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
//    convenience init(frame: CGRect, name: String) {
//        self.init(frame: frame)
//        setViews(name: name)
//    }
    
    func setViews() {
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        
        self.nameLabel.text = currentUser.logUserName
        
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
