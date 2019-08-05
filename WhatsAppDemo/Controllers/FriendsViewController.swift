//
//  FriendsViewController.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/7/29.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit
import Moya
import SnapKit
import SwiftyJSON

class FriendsViewController: UIViewController {
    
    let tableView = UITableView()
    let provider = MoyaProvider<Contacts>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if self.isViewLoaded {
            getContacts()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setView()
        getContacts()
    }
    
    func setView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-tabBarHeight)
        }
        self.tableView.tableFooterView = UIView()
    }
    
    func getContacts() {
        self.provider.manager.session.configuration.timeoutIntervalForRequest = 10
        provider.request(.getContacts) { (result) in
            switch result {
            case let .success(response):
                if let data = try? response.mapJSON() {
                    let json = JSON(data)
                    print(json)
                    currentUser.contact = []
                    for index in 0..<json.count {
                        currentUser.contact.append(json[index]["account"].stringValue)
                    }
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }

}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.contact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "FriendsTableViewCell")
        }
        
        cell?.textLabel?.text = currentUser.contact[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async{ //在主线程运行避免cell.selectionStyle = .none时弹出延时
            let vc = ChatViewController()
            vc.chattingUser = currentUser.contact[indexPath.row]
            if currentUser.megList.contains(currentUser.contact[indexPath.row]){
                
            } else {
                currentUser.megList.append(currentUser.contact[indexPath.row])
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
