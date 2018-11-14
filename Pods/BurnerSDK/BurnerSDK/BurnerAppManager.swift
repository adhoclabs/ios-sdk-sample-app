//
//  BurnerAppManager.swift
//  BurnerSDK
//
//  Created by William Carter on 2/26/18.
//  Copyright © 2018 Burner. All rights reserved.
//

import UIKit

class BurnerAppManager {
    
    public class func openOrDownloadText() -> String {

        let burnerInstalledText = "Open Burner"
        let burnerNotInstalledText = "Download the App"
        
        return burnerInstalled() ? burnerInstalledText : burnerNotInstalledText
    }
    
    public class func burnerInstalled() -> Bool {
        
        if let url = URL(string: "burner://") {
            if UIApplication.shared.canOpenURL(url as URL) {
                return true
            }
        }
        
        return false
    }
        
    public class func openAppOrStore() {
        
        // check if burner:// scheme exists
        
        if let url = URL(string: "burner://") {
            if UIApplication.shared.canOpenURL(url as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                return
            }
        }
        
        // open burner download link
        let appStoreLink = "https://itunes.apple.com/us/app/apple-store/id505800761??mt=8"
        if let url = URL(string: appStoreLink), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
}
