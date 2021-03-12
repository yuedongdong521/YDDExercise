//
//  YDDShareManager.swift
//  YDDExercise
//
//  Created by ydd on 2021/3/8.
//  Copyright © 2021 ydd. All rights reserved.
//

import Foundation

@objcMembers class YDDShareManager: NSObject {
    
    
     public func shareFile(_ url: URL?) {
        guard let url = url else {
            return
        }
        let inter = UIDocumentInteractionController(url: url)
        inter.delegate = self
        inter.presentPreview(animated: true)
    }
}


extension YDDShareManager: UIDocumentInteractionControllerDelegate {
 

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let window = UIApplication.shared.delegate?.window else {
            return UIViewController()
        }
        
        guard let vc = window?.rootViewController  else {
            return UIViewController()
        }
        
        return vc
    }

    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        
        guard let window = UIApplication.shared.delegate?.window else {
            return nil
        }
        return window
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
    
        return UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0))
    }
    
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        SwiftLog("documentInteractionControllerWillBeginPreview")
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        SwiftLog("documentInteractionControllerDidEndPreview")
    }
    
    func documentInteractionControllerWillPresentOptionsMenu(_ controller: UIDocumentInteractionController) {
        SwiftLog("documentInteractionControllerWillPresentOptionsMenu")
    }
    
    func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
        SwiftLog("documentInteractionControllerDidDismissOptionsMenu")
    }
    
    func documentInteractionControllerWillPresentOpenInMenu(_ controller: UIDocumentInteractionController) {
        SwiftLog("documentInteractionControllerWillPresentOpenInMenu")
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        SwiftLog("documentInteractionControllerDidDismissOpenInMenu")
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        
        SwiftLog("willBeginSendingToApplication \(application ?? "")")
        
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        SwiftLog("didEndSendingToApplication \(application ?? "")")
    }
    
    
}

