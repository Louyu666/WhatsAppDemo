//
//  LoginTextField.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/4.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

    //重写draw方法实现下划线textField
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1))
    }
}
