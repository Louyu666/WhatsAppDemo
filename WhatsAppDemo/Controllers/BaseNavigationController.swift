//
//  BaseNavigationController.swift
//  WhatsAppDemo
//
//  Created by louyu on 2019/7/30.
//  Copyright © 2019 louyu. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    // MARK: LifeCycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.barStyle = .default
        navigationBar.isTranslucent = false

//        navigationBar.shadowImage = UIImage()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //重写此方法让 preferredStatusBarStyle 响应
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
