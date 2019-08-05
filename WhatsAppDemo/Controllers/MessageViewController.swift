//
//  MessageViewController.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/7/29.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class MessageViewController: UIViewController {
    
    let tableView = UITableView()
    let provider = MoyaProvider<AddContacts>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if self.isViewLoaded {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    func setViews() {
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChatAction))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-tabBarHeight)
        }
        tableView.tableFooterView = UIView()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func addChatAction() {
        let alertView = UIAlertController(title: "Enter the user you wanna chat.", message: nil, preferredStyle: .alert)
        alertView.addTextField { (textField) in }
        let action1 = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
            let text = alertView.textFields![0].text
            if text == currentUser.logUserName {
                self.chatWithSelf()
            }
            if text != "" {
                //判断输入的用户是否存在
                self.provider.manager.session.configuration.timeoutIntervalForRequest = 10
                self.provider.request(.addContact(sendUser: text!)) { (result) in
                    switch result {
                    case let .success(response):
                        let data = try? response.mapJSON()
                        let json = JSON(data!)
                        let statusString = json["status"].string!
                        if statusString == "OK" {
                            let vc = ChatViewController()
                            vc.chattingUser = text!
                            if currentUser.megList.contains(text!){
                                
                            } else {
                                currentUser.megList.append(text!)
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            self.authUserFailed()
                        }
                    case .failure(_):
                        break
                    }
                }
            } else {
                self.alertTextIsEmpty()
            }
        })
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(action1)
        alertView.addAction(action2)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func alertTextIsEmpty() {
        let alertView = UIAlertController(title: "User name is empty.", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
            self.addChatAction()
        })
        alertView.addAction(action1)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func chatWithSelf() {
        let alertView = UIAlertController(title: "You cannot chat with your self!", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
            self.addChatAction()
        })
        alertView.addAction(action1)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func authUserFailed() {
        let alertView = UIAlertController(title: "The user is not existed.", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
            self.addChatAction()
        })
        alertView.addAction(action1)
        self.present(alertView, animated: true, completion: nil)
    }
}

extension MessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.megList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "FriendsTableViewCell")
        }
        
        cell?.textLabel?.text = currentUser.megList[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async{ //在主线程运行避免cell.selectionStyle = .none时弹出延时
            let vc = ChatViewController()
            vc.chattingUser = currentUser.megList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
