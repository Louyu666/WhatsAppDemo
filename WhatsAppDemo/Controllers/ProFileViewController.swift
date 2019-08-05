//
//  MineViewController.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/7/29.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import SwiftyJSON
import MBProgressHUD

class ProFileViewController: UIViewController {
    
    let headView = ProFileHeaderView()
    let tableView = UITableView()
    let cellContent = ["Change Password","Logout"]
    let provider = MoyaProvider<PasswdChange>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.headView.nameLabel.text = currentUser.logUserName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setViews() {
        self.view.addSubview(headView)
        self.view.addSubview(tableView)
        headView.snp.makeConstraints { (make) in
            make.top.equalTo(topBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.bottom.equalTo(-tabBarHeight)
            make.left.right.equalToSuperview()
        }
        tableView.tableFooterView = UIView()
    }
    
    
}

extension ProFileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ProFileTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ProFileTableViewCell")
        }
        
        cell?.textLabel?.text = cellContent[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async{ //在主线程运行避免cell.selectionStyle = .none时弹出延时
            if indexPath.row == 0 {
                self.changePasswd()
            } else {
                let alertView = UIAlertController(title: "Really wanna logout?", message: nil, preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK", style: .destructive, handler: { (UIAlertAction) -> Void in
                    currentUser.logUserName = ""
                    currentUser.contact = []
                    currentUser.megList = []
                    appDelegate.self?.window?.rootViewController = logVC
                })
                let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertView.addAction(action1)
                alertView.addAction(action2)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func alertTextIsEmpty() {
        let alertView = UIAlertController(title: "New password is empty.", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
            self.changePasswd()
        })
        alertView.addAction(action1)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func changePasswd() {
        let alertView = UIAlertController(title: "Enter the password you wanna change.", message: nil, preferredStyle: .alert)
        alertView.addTextField { (textField) in
            textField.isSecureTextEntry = true
        }
        let action1 = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
            let text = alertView.textFields![0].text
            if text != "" {
                
            } else {
                self.alertTextIsEmpty()
                return
            }
            self.provider.manager.session.configuration.timeoutIntervalForRequest = 10
            self.provider.request(.changePasswd(newpasswd: text!), completion: { (result) in
                switch result {
                case let .success(response):
                    let data = try? response.mapJSON()
                    let json = JSON(data!)
                    let statusString = json["status"].string!
                    if statusString == "OK" {
                        self.passwdHasChanged()
                    } else {
                        self.passwdChangeFailed()
                    }
                case .failure(_):
                    break
                }
            })
        })
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(action1)
        alertView.addAction(action2)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func passwdHasChanged() {
        let alertView = UIAlertController(title: "Password has changed.", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(action1)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func passwdChangeFailed() {
        let alertView = UIAlertController(title: "Something wrong.", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(action1)
        self.present(alertView, animated: true, completion: nil)
    }
    
}
