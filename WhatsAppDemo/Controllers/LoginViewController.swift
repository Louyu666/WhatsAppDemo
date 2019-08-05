//
//  LoginViewController.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/7/29.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import Moya
import MBProgressHUD

class LoginViewController: UIViewController {

    let backGroundImageView = UIImageView(image: UIImage(named: "loginBackground"))
    let headImageView = UIImageView(image: UIImage(named: "default-profilephoto"))
    let accountTextField = LoginTextField()
    let passwordTextField = LoginTextField()
    let loginBtn = UIButton()
    let registerBtn = UIButton()
    let provider = MoyaProvider<Login>()
    var loginVerResult = ""
    var loginHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
        self.view.addSubview(backGroundImageView)
        self.view.addSubview(headImageView)
        self.view.addSubview(accountTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginBtn)
        self.view.addSubview(registerBtn)
        
        backGroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        headImageView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.centerY).offset(-50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
            headImageView.layer.masksToBounds = true
            headImageView.layer.cornerRadius = 150/2
        }
        
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(90*2)
            make.height.equalTo(20*2)
            accountTextField.placeholder = "User Name"
            accountTextField.clearButtonMode = .whileEditing
         
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalTo(90*2)
            make.height.equalTo(20*2)
            make.centerX.equalToSuperview()
            make.top.equalTo(accountTextField.snp.bottom).offset(32)
            passwordTextField.placeholder = "Password"
            passwordTextField.isSecureTextEntry = true
        }
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(60)
            loginBtn.setTitle("Login", for: .normal)
            loginBtn.backgroundColor = UIColor(hex: "9D9595")
            loginBtn.layer.masksToBounds = true
            loginBtn.layer.cornerRadius = 60/2
            loginBtn.addTarget(self, action: #selector(logBtnTapped), for: .touchUpInside)
        }
        
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            registerBtn.setTitle("Register...", for: .normal)
            registerBtn.addTarget(self, action: #selector(regBtnTapped), for: .touchUpInside)
        }
        
        self.view.addSubview(loginHUD)
        loginHUD.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        loginHUD.label.text = "Login..."
        
    }
    
    @objc func logBtnTapped() {
        if accountTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alertView = UIAlertController(title: "Account or password cannot be empty!", message: nil, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(action1)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        loginHUD.show(animated: true)
        // MARK: - 设置请求超时时间
        
        provider.request(.pushLogMessage(account: accountTextField.text!, password: passwordTextField.text!), progress: nil) { (result) in
            switch result {
            case let .success(response):
                if let data = try? response.mapJSON() {
                    let json = JSON(data)
                    self.loginVerResult = json["status"].string!
                } else {
                    print("something wrong...")
                }
                self.loginHUD.hide(animated: true)
                if self.loginVerResult == "OK"{
                    currentUser.logUserName = self.accountTextField.text!
                    mainVC = MainViewController()
                    appDelegate.self?.window?.rootViewController = mainVC
                } else {
                    let alertView = UIAlertController(title: self.loginVerResult, message: nil, preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertView.addAction(action1)
                    self.present(alertView, animated: true, completion: nil)
                }
                
            case .failure(_):
                self.loginHUD.hide(animated: true)
                let alertView = UIAlertController(title: "Connect Failed", message: nil, preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertView.addAction(action1)
                self.present(alertView, animated: true, completion: nil)
                break
            }
        }
    }

    @objc func regBtnTapped() {
        let vc = RegisterViewController()
        self.present(vc, animated: false, completion: nil)
    }
    
}



