//
//  AppDelegate.swift
//  EvaluationTask
//
//  Created by Amani Tawalbeh on 2/17/22.
//

import UIKit
import KVNProgress
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        self.window?.rootViewController = vc
        
        return true
    }


    

}

