//
//  AlertView.swift
//  RemotevalProject
//
//  Created by Akash Sheth on 05/01/23.
//

import Foundation
import UIKit


class Alert {
    
    static var shared = Alert()
    
    func show(title:String? = nil,message:String?,preferredStyle: UIAlertController.Style = .alert,buttons:[String] = ["Ok"],sourceRect:CGRect? = nil,completionHandler: ((String) -> Void)? = nil)  -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for button in buttons{
            
            var style = UIAlertAction.Style.default
            let buttonText = button.lowercased().replacingOccurrences(of: " ", with: "")
            if buttonText.caseInsensitiveCompare("cancel") == .orderedSame,
               UIDevice.current.userInterfaceIdiom != .pad{
                style = .destructive
            } else if buttonText.caseInsensitiveCompare("Discard") == .orderedSame,
               UIDevice.current.userInterfaceIdiom != .pad{
                style = .destructive
            } else if buttonText.caseInsensitiveCompare("exit") == .orderedSame,
               UIDevice.current.userInterfaceIdiom != .pad{
                style = .destructive
            } else if buttonText.caseInsensitiveCompare("Dismiss") == .orderedSame,
               UIDevice.current.userInterfaceIdiom != .pad{
                style = .destructive
            } else if buttonText.caseInsensitiveCompare("leavecall") == .orderedSame,
               UIDevice.current.userInterfaceIdiom != .pad{
                style = .destructive
            } else if buttonText.caseInsensitiveCompare("deny") == .orderedSame,
                      UIDevice.current.userInterfaceIdiom != .pad {
                style = .destructive
            } else if buttonText.caseInsensitiveCompare("discardscan") == .orderedSame,
                      UIDevice.current.userInterfaceIdiom != .pad {
                style = .destructive
            }

            let action = UIAlertAction(title: button, style: style) { (_) in
                completionHandler?(button)
            }
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            if let rootViewController = UIViewController.getVisibleViewController(nil){
                if UIDevice.current.userInterfaceIdiom == .pad,preferredStyle == .actionSheet {
                    if let rect = sourceRect{
                        alert.popoverPresentationController?.sourceRect = rect
                    }else{
                        alert.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
                        alert.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 300, width: 200, height: 600)
                    }
                    
                    alert.popoverPresentationController?.sourceView = rootViewController.view
                    rootViewController.present(alert, animated: true, completion: nil)
                }  else {
                    rootViewController.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        return alert
    }
    
    
    func showProgressWith(_ text: String? = nil, message: String? = nil, updateProgress: Float = 0.0, buttons: [String] = [], buttonTap: ((String) -> Void)? = nil, completionHandler: (() -> Void)? = nil) -> UIAlertController {
        var alertReturn = UIAlertController(title: text, message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
    
            if let presentedAlert = UIViewController.getVisibleViewController(nil) as? UIAlertController,
               presentedAlert.accessibilityLabel == "progress_alert" {
                
                alertReturn = presentedAlert
                if let text = text { presentedAlert.title = text }
                if let label = presentedAlert.view.subviews.first(where: { $0.accessibilityLabel == "progress_alert_label" }) as? UILabel {
                    label.text = message
                }
                if let progressView = presentedAlert.view.subviews.first(where: { $0.accessibilityLabel == "progress_alert_progress" }) as? UIProgressView {
                    progressView.setProgress(updateProgress, animated: true)
                }
                
            } else {
                
                let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
                alert.accessibilityLabel = "progress_alert"
                alertReturn = alert
                
                let confirmLabel = UILabel()
                confirmLabel.accessibilityLabel = "progress_alert_label"
                confirmLabel.translatesAutoresizingMaskIntoConstraints = false
                confirmLabel.textAlignment = .center
                confirmLabel.numberOfLines = 0
                confirmLabel.text = message
                confirmLabel.textColor = .black
                confirmLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
                
                let progressView = UIProgressView()
                progressView.trackTintColor = UIColor.lightGray
                progressView.progressTintColor = UIColor.systemBlue
                progressView.accessibilityLabel = "progress_alert_progress"
                progressView.translatesAutoresizingMaskIntoConstraints = false
                progressView.setProgress(updateProgress, animated: true)
                progressView.trackTintColor = UIColor.lightGray
                progressView.progressTintColor = UIColor.systemBlue
                alert.view.addSubview(confirmLabel)
                alert.view.addSubview(progressView)
                
                NSLayoutConstraint.activate([
                    confirmLabel.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50),
                    confirmLabel.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                    confirmLabel.widthAnchor.constraint(equalToConstant: 240),
                    progressView.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: 16),
                    progressView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: buttons.isEmpty ? -20 : -60),
                    progressView.widthAnchor.constraint(equalToConstant: 240),
                    progressView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor)
                ])
                
                let height = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: buttons.isEmpty ? 140 : 180)
                alert.view.addConstraint(height)
                
                for button in buttons {
                    let action = UIAlertAction(title: button, style: .default) { _ in
                        buttonTap?(button)
                    }
                    alert.addAction(action)
                }
            }
            
        }
        return alertReturn
    }
    
    func dismissedAllAlert(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let alert = UIViewController.getVisibleViewController(nil) as? UIAlertController {
                alert.dismiss(animated: animated) {
                    self.dismissedAllAlert(completion: completion)
                }
            } else {
                completion?()
            }
        }
    }
    
    func dismiss(completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let rootViewController = UIViewController.getVisibleViewController(nil) {
                rootViewController.dismiss(animated: true, completion: completionHandler)//dismiss(animated: true)
            }
        }
    }
}


extension UIViewController {
    
    static func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        }
        
        var presented = rootVC?.presentedViewController
        if rootVC?.presentedViewController == nil {
            if let isTab = rootVC?.isKind(of: UITabBarController.self), let isNav = rootVC?.isKind(of: UINavigationController.self) {
                if !isTab && !isNav {
                    return rootVC
                }
                presented = rootVC
            } else {
                return rootVC
            }
        }
        
        if let presented = presented {
            if presented.isKind(of: UINavigationController.self) {
                if let navigationController = presented as? UINavigationController {
                    return navigationController.viewControllers.last!
                }
            }
            
            if presented.isKind(of: UITabBarController.self) {
                if let tabBarController = presented as? UITabBarController {
                    if let navigationController = tabBarController.selectedViewController! as? UINavigationController {
                        return navigationController.viewControllers.last!
                    } else {
                        return tabBarController.selectedViewController!
                    }
                }
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
}
