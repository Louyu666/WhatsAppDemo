//
//  ChatViewController.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/8/3.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import SwiftyJSON

class ChatViewController: UIViewController {
    
    let tableView = UITableView()
    var chattingUser = String()
    let chatButtomView = ChatButtomView()
    let provider = MoyaProvider<Message>()
    var messages = [MessageModel]()
    var timer = Timer()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.provider.manager.session.configuration.timeoutIntervalForRequest = 10
        getMessage()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getDataInInterval), userInfo: nil, repeats: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = chattingUser
        setView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.timer.invalidate()
        }
    }
    
    func setView() {
        self.view.addSubview(chatButtomView)
        self.view.addSubview(tableView)
        
        chatButtomView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(chatButtomView.snp.top)
        }
        tableView.register(ChatMessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        chatButtomView.sendBtn.addTarget(self, action: #selector(sendBtnTapped), for: .touchUpInside)
    }
    
    @objc func sendBtnTapped() {
        self.chatButtomView.messageTextView.endEditing(true)
        let textString = self.chatButtomView.messageTextView.text
        self.chatButtomView.messageTextView.text = ""
        if textString == "" {
            let alertView = UIAlertController(title: "Tips", message: "You cannot send blank message.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(action1)
            self.present(alertView, animated: true, completion: nil)
            return
        }
        provider.request(.postMsg(sendUser: chattingUser, content: textString!)) { (result) in
            switch result {
            case let .success(response):
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let postResult = json["status"].stringValue
                if postResult == "OK" {
                    print("OK")
                    let msg = MessageModel(message: textString!, messageSender: .ourself, username: currentUser.logUserName)
                    self.insertNewMessageCell(msg)
                }
            case .failure(_):
                break
            }
        }
    }
    
    @objc func getDataInInterval() {
        self.getMessage()
    }


    func getMessage() {
        provider.request(.getMsg) { (result) in
            switch result {
            case let .success(response):
                if let data = try? response.mapJSON() {
                    let json = JSON(data)
                    print(json)
                    for index in 0..<json.count {
                        let msg = MessageModel(message: json[index]["content"].stringValue, messageSender: .someoneElse, username: json[index]["senduser"].stringValue)
                        self.insertNewMessageCell(msg)
                    }
                }
            case .failure(_):
                break
            }
        }
    }

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? ChatMessageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        let message = messages[indexPath.row]
        cell.apply(message: message)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = ChatMessageTableViewCell.height(for: messages[indexPath.row])
        return height
    }
    
    func insertNewMessageCell(_ message: MessageModel) {
        messages.append(message)
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
}
