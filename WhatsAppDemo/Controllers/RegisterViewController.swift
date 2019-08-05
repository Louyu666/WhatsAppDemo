//
//  RegisterViewController.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/4.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import SnapKit
import MBProgressHUD

class RegisterViewController: UIViewController {
    
    let backGroundImageView = UIImageView(image: UIImage(named: "loginBackground"))
    let titleLabel = UILabel()
    let accountTextField = LoginTextField()
    let passwordTextField = LoginTextField()
    let goBtn = UIButton()
    let backBtn = UIButton()
    let provider = MoyaProvider<Register>()
    var regVerResult = ""
    var loginHUD = MBProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
        self.view.addSubview(backGroundImageView)
        self.view.addSubview(accountTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(titleLabel)
        self.view.addSubview(goBtn)
        self.view.addSubview(backBtn)
        
        backGroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        accountTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.centerY).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(90*2)
            make.height.equalTo(20*2)
            accountTextField.placeholder = "User Name"
            accountTextField.clearButtonMode = .whileEditing
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(accountTextField.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(90*2)
            make.height.equalTo(20*2)
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(accountTextField.snp.top).offset(-40)
            make.left.equalTo(accountTextField)
            titleLabel.text = "Register"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        }
        
        goBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(60)
            goBtn.setTitle("Go!", for: .normal)
            goBtn.backgroundColor = UIColor(hex: "9D9595")
            goBtn.layer.masksToBounds = true
            goBtn.layer.cornerRadius = 60/2
            goBtn.addTarget(self, action: #selector(goBtnTapped), for: .touchUpInside)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(goBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            backBtn.setTitle("Back...", for: .normal)
            backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        }
        
        self.view.addSubview(loginHUD)
        loginHUD.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        loginHUD.label.text = "Registering..."
    }
    
    @objc func goBtnTapped() {
        if accountTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alertView = UIAlertController(title: "Account or password cannot be empty!", message: nil, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(action1)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        loginHUD.show(animated: true)
        self.provider.manager.session.configuration.timeoutIntervalForRequest = 10 //设置请求超时时间
        provider.request(.pushRegMessage(account: accountTextField.text!, password: passwordTextField.text!)) { (result) in
            switch result {
            case let .success(response):
                if let data = try? response.mapJSON() {
                    let json = JSON(data)
                    self.regVerResult = json["status"].string!
                } else {
                    print("something wrong...")
                }
                self.loginHUD.hide(animated: true)
                if self.regVerResult == "OK"{
                    currentUser.logUserName = self.accountTextField.text!
                    mainVC = MainViewController()
                    appDelegate.self?.window?.rootViewController = mainVC
                } else {
                    let alertView = UIAlertController(title: "This account has been registered.", message: nil, preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertView.addAction(action1)
                    self.present(alertView, animated: true, completion: nil)
                }
            case .failure(_):
                break
            }
        }
    }
    
    @objc func backBtnTapped() {
        self.dismiss(animated: false, completion: nil)
    }
}
