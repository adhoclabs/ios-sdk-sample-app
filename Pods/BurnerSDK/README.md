# iOS-SDK

This is a simple SDK wrapper for Burner's OAuth implementation.

It allows developer to given a Client ID and Secret, present a modal WKWebView that handles Burner register/login flow, inclusive of Sample Burner creation.

It will expose to the developer a Burner object and a OAuth object. The Burner object is the first Burner found on their account (this is optimized for a sample create flow). The OAuth object contains info about the user's access token. This token can't currently be used for anything but could be useful in the future.

### Persistence

After the OAuth flow has been completed and the OAuth access token is sent back to the client developer via a completion block, the SDK will persist the OAuth token. Subsequent calls to the primary SDK `start` method will use the persisted access token to retreive a list of the user's current Burners and display them via native UI.

### Public SDK Methods

Run the test app in the simulator. You'll see a button that will allow you to get a burner phone number. In the test project, you can see the phone number returned in the completion handler. Use the clientId and clientSecret provided to you by your Burner contact.

##### start
```

BurnerSDK.shared.start(clientId: "CLIENT_ID_HERE", 
                       clientSecret: "CLIENT_SECRET_HERE") 
                       { (burner, oauth, error) in

    guard let burner = burner, let oauth = oauth else {
        return
    }

    // print the burner phone number
    print("burner: \(burner.phoneNumber)")            
}
        
```

After the user goes through the signup flow and the completion block is called, subsequent calls to `start` will display a modal with a list of the user's active burners. If you want to re-authenticate the user, simply clear the credentials by calling

```BurnerSDK.shared.removeCredentials()```

Before calling `start` again.

There are also 2 convenience methods, one to open Burner if it exists on a user's phone, or alternatively direct the user to the Burner page on the Apple App Store, and one to check the SDK version.

##### openBurnerApp

```BurnerSDK.shared.openBurnerApp()```

##### sdkVersion

```
if let version = BurnerSDK.shared.sdkVersion() {
    print("version: \(version)")
}
```

Note: If a developer wants to use the SDK method `openBurnerApp()` they'll also need to define a value in your app's Info.plist:

```
<key>LSApplicationQueriesSchemes</key>
<array>
<string>burner</string>
</array>
```

for iOS 9+ this allows us to look for an open burner on the user's phone.

That's it! You can access other properties of the Burner number as well:

```
* `dateCreated: Int` - the date the Burner was created in unix time
* `expires: Int` - the expiration date of the Burner in unix time
* `id: String` - the id of the Burner
* `name: String` - the name of the Burner, provided by it's owner
* `notifications: Bool` - should incoming texts and calls to this number trigger push notifications
* `phoneNumber: String` - the phone number of the Burner
* `remainingMinutes: Int` - the number of minutes remaining on the Burner
* `remainingTexts: Int` - the number of texts remaining on the Burner
* `ringer: Bool` - should the Burner ring or go straight to voicemail
```
