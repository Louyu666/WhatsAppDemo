//
//  MainViewController.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/7/29.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.selectedIndex = 0
    }

    override func viewDidLoad() {
        initViewControllers()
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    func initViewControllers() {
        let VC1 = MessageViewController()
        let VC2 = FriendsViewController()
        let VC3 = ProFileViewController()

        creatTabbarView(viewController: VC1, image: "chat-barIcon", selectImage: "chat-barIcon-selected", title: "Messages")
        creatTabbarView(viewController: VC2, image: "contacts-barIcon", selectImage: "contacts-barIcon-selected", title: "Contacts")
        creatTabbarView(viewController: VC3, image: "me-barIcon", selectImage: "me-barIcon-selected", title: "Profile")
        let subViewControllers = [VC1, VC2, VC3]
        let navigationViewControllers = subViewControllers.map {
            subViewController -> UIViewController in
            subViewController.view.frame = self.view.frame
            subViewController.view.bounds = self.view.bounds
            subViewController.extendedLayoutIncludesOpaqueBars = true
            
            return BaseNavigationController(rootViewController: subViewController)
        }
        self.viewControllers = navigationViewControllers
        self.tabBar.tintColor = UIColor(red: 85/255, green: 183/255, blue: 55/255, alpha: 1)
    }
    
    func creatTabbarView(viewController:UIViewController, image:String, selectImage:String, title:String) {
        // alwaysOriginal 始终绘制图片原始状态，不使用Tint Color。
        viewController.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.selectedImage = UIImage(named: selectImage)?.withRenderingMode(.alwaysOriginal)
        viewController.title = title
    }
    
    

}
