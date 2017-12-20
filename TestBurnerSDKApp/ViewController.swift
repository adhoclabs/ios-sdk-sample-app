//
//  ViewController.swift
//  TestBurnerSDKApp
//
//  Created by William Carter on 12/20/17.
//  Copyright © 2017 William Carter. All rights reserved.
//

import UIKit
import BurnerSDK

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let version = BurnerSDK.shared.sdkVersion() {
            print("version: \(version)")
        } else {
            print("version not found")
        }
        
    }
    
    func openAppOrStore() {
        
        // check if burner:// scheme exists
        
        BurnerSDK.shared.openBurnerApp()
        
    }

    @IBAction func removeCredentials(_ sender: Any) {
        
        BurnerSDK.shared.removeCredentials()
    }
    
    @IBAction func openBurnerApp(_ sender: Any) {
        
        openAppOrStore()
        
    }
    
    @IBAction func getPhoneNumber(_ sender: Any) {
        
        
        BurnerSDK.shared.start(clientId: "CLIENT_ID", clientSecret: "CLIENT_SECRET") { (burner, oauth, error) in

            guard let burner = burner, let oauth = oauth else {
                return
            }
            
            // print the burner phone number
            print("burner: \(burner.phoneNumber)")
            
            self.textView.text = burner.phoneNumber
            
            /* other burner parameters
             
             * dateCreated: Int
             * expires: Int
             * hexColor: Int
             * id: String
             * name: String
             * notifications: Bool
             * phoneNumber: String
             * remainingMinutes: Int
             * remainingTexts: Int
             * ringer: Bool
             * sip: Bool
             * totalMinutes: Int
             * totalTexts: Int
             
            */
            
            // print the access token
            print("access token: \(oauth.access_token)")
            
            /* other auth parameters
 
             access_token: String
             expires_in: Int
             scope: String
             token_type: String
             */
            
        }
        
    }
}

