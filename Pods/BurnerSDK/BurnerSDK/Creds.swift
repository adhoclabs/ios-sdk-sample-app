import Foundation

/*
 Set the BURNER_CLIENT_ID, BURNER_SECRET, BURNER_HOST and
 BURNER_API in the target's scheme
 
 Target -> Edit scheme -> Run -> Arguments
 */

class Creds {

    static let shared = Creds()
    
    var host: String {
        return "https://app.burnerapp.com"
    }

    var api: String {
        return "https://api.burnerapp.com"
    }
    
    var scope: String {
        return "burners:read burners:write contacts:read contacts:write"
    }
    
    var randomString: NSString {
        
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = 32
        let randomString: NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0...len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }

    func hasConnectScope() -> Bool {
    
        return Creds.shared.scope.contains("messages:connect")
    }

    
}
