//
//  Burner.swift
//  BurnerSDK
//
//  Created by William Carter on 12/20/17.
//  Copyright © 2017 William Carter. All rights reserved.
//

import UIKit

public typealias BurnerCompletionHandler = (_ burner: Burner?, _ oauth: OAuth?, _ error: Error?) -> Void
public typealias BurnersCompletionHandler = (_ burners: [Burner]?, _ error: Error?) -> Void

public class BurnerSDK: NSObject, UIViewControllerTransitioningDelegate {

    let namespace = "BURNER_"
    let phoneNumberKey = "burnerPhoneNumber"
    let nameKey = "burnerName"
    let tokenKey = "accessToken"
    let expiresInKey = "expiresIn"
    
    var accessToken: String? {
        get {
            
            // check if this is still valid
            if let expiresIn = UserDefaults.standard.value(forKey: "\(namespace)\(tokenKey)") as? Int {
                let expireDate = Date(timeIntervalSince1970: TimeInterval(expiresIn))
                let today = Date()
                if expireDate > today {
                    self.removeCredentials()
                    return nil
                }
            }
            
            return UserDefaults.standard.value(forKey: "\(namespace)\(tokenKey)") as? String
        }
    }
    
    let transition = SlideAnimator()
    public static let shared = BurnerSDK()
    public var clientId: String?
    public var clientSecret: String?
    public var clientName: String? // display name when needed
    
    //MARK: Public SDK methods
    
    public func start(clientId: String, clientSecret: String, completion: @escaping BurnerCompletionHandler) {

        self.clientId = clientId
        self.clientSecret = clientSecret
        
        if let token = accessToken {
            
            print("access token found, finding burners")
            if let window = UIApplication.shared.keyWindow {
                startViewBurnersIn(window, token: token, completion: completion)

            }
            return
        }
        
        print("no token found, starting OAuth process")
        
        if let window = UIApplication.shared.keyWindow {
            startOAuthIn(window, completion: { (burner, oauth, error) in
                self.persistBurner(burner: burner, oauth: oauth)
                completion(burner, oauth, error)
            })
        }
    }
    
    public func removeCredentials() {
        
        UserDefaults.standard.removeObject(forKey: "\(namespace)\(phoneNumberKey)")
        UserDefaults.standard.removeObject(forKey: "\(namespace)\(tokenKey)")
        UserDefaults.standard.removeObject(forKey: "\(namespace)\(nameKey)")
        UserDefaults.standard.removeObject(forKey: "\(namespace)\(expiresInKey)")
        UserDefaults.standard.synchronize()
    }
    
    public func openBurnerApp() {
        print("DEBUG: opening burner app")
        BurnerAppManager.openAppOrStore()
    }
    
    public func sdkVersion() -> String? {
        let bundle = Bundle.init(for: type(of: self))
        if let info = bundle.infoDictionary, let ver = info["CFBundleShortVersionString"] as? String {
            return ver
        } else {
            return nil
        }
    }
    
    //MARK: Internal
    
    internal func persistBurner(burner: Burner?, oauth: OAuth?) {
        
        if let burner = burner, let oauth = oauth {
            
            print("persisting burner")
            
            UserDefaults.standard.set(burner.phoneNumber, forKey: "\(namespace)\(phoneNumberKey)")
            UserDefaults.standard.set(burner.name, forKey: "\(namespace)\(nameKey)")
            UserDefaults.standard.set(oauth.access_token, forKey: "\(namespace)\(tokenKey)")
            UserDefaults.standard.set(oauth.expires_in, forKey: "\(namespace)\(expiresInKey)")
            UserDefaults.standard.synchronize()

        }
        
    }
    
    internal func startViewBurnersIn(_ window: UIWindow, token: String?, completion: @escaping BurnerCompletionHandler) {
        
        let bundle = Resource().bundle()
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ExistingUserController") as? ExistingUserViewController {
            
            vc.completion = completion
            vc.token = token

            vc.view.frame = window.bounds
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .overFullScreen
            
            if let rootController = window.rootViewController {
                
                if let presentedController = rootController.presentedViewController {
                    presentedController.present(vc, animated: true, completion: nil)
                } else {
                    rootController.present(vc, animated: true, completion: nil)
                }
            }
            
            completion(nil, nil, nil)
        }
    }
    
    internal func startOAuthIn(_ window: UIWindow, completion: @escaping BurnerCompletionHandler) {
        
        let bundle = Resource().bundle()
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        
        if let vc = storyboard.instantiateInitialViewController() as? UINavigationController {
            let authViewController = vc.viewControllers.first as? BurnerAuthorizationViewController
            authViewController?.completion = completion

            vc.view.frame = window.bounds
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .overFullScreen
            
            if let rootController = window.rootViewController {
                
                if let presentedController = rootController.presentedViewController {
                    presentedController.present(vc, animated: true, completion: nil)
                } else {
                    rootController.present(vc, animated: true, completion: nil)
                }
            }
        }

    }
    
    //MARK: Animations
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = true
        
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = false
        return transition
    }
    
}
