//
//  MessageLabel.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/4.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit

class MessageLabel: UILabel {

    override func drawText(in rect: CGRect) {
        super.drawText(in: bounds.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)))
    }

}
