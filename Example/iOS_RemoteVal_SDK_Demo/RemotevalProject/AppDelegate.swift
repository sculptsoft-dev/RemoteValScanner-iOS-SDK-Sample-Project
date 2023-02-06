//
//  AppDelegate.swift
//  RemotevalProject
//
//  Created by Akash Sheth on 15/11/22.
//

import UIKit
import RemotevalSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var orientationLock = UIInterfaceOrientationMask.portrait
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = #colorLiteral(red: 0.2470588235, green: 0.4862745098, blue: 0.8039215686, alpha: 1)
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        RVConfigClass.shared.applicationStateEnterInBackground(window: self.window)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        RVConfigClass.shared.applicationStateBecomeInActive(window: self.window)
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }



}

extension AppDelegate {
    
    static func rotateToLandscapeRightDevice() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .landscapeRight
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIView.setAnimationsEnabled(false)
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
    
    static func rotateToPotraitDevice() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIView.setAnimationsEnabled(false)
            UINavigationController.attemptRotationToDeviceOrientation()
        }
    }
}

