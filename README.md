# ios-sdk-sample-app
Sample App for Burner iOS SDK

This repository includes a simple sample app for the Burner iOS SDK.

### First things first

Before you get started you'll need a `Client ID` and `Client Secret` provided to you by the Burner team.

Keep track of these values, you'll need them to use the SDK.

You'll also need to download & link the Burner SDK Framework to this project. The framework will be provided to you by your contact at Burner.

Drag the BurnerSDK.framework file to your project and copy the framework files to the test project.

### Run the test app

Run the test app in the simulator. You'll see a button that will allow you to get a burner phone number. In the test project, you can see the phone number returned in the completion handler. Use the clientId and clientSecret provided to you by your Burner contact.

```
@IBAction func getPhoneNumber(_ sender: Any) {
        BurnerSDK.shared.start(clientId: "CLIENT_ID_HERE", 
                               clientSecret: "CLIENT_SECRET_HERE") 
                               { (burner, oauth, error) in
            
            guard let burner = burner, let oauth = oauth else {
                return
            }
            
            // print the burner phone number
            print("burner: \(burner.phoneNumber)")            
        }
        
    }
```

### Use the SDK in your own project

Include the Framework in your project target. Your app will throw an exception if any of the values aren't provided.

To include the framework in your project, drag the BurnerSDK.framework file into your app's XCode project. Verify the framework is linked by:

* Tap on your project file in XCode
* Select your App's Target
* Tap on Build Phases
* Verify the BurnerSDK.framework is in the Link Binary with Libraries section

You only need to call one line of code to get a phone number from Burner that your users can use.

```

BurnerSDK.shared.start(clientId: "CLIENT_ID_HERE", clientSecret: "CLIENT_SECRET_HERE") { (burner, oauth, error) in

  print("burner: \(burner.phoneNumber)")
}
```

After the user goes through the signup flow and the completion block is called, subsequent calls to `start` will display a modal with a list of the user's active burners. If you want to re-authenticate the user, simply clear the credentials by calling

```BurnerSDK.shared.removeCredentials()```

Before calling `start` again.

There are also 2 convenience methods, one to open Burner if it exists on a user's phone, or alternatively direct the user to the Burner page on the Apple App Store:

```BurnerSDK.shared.openBurnerApp()```

and the other to check the version of the Burner SDK:

```
if let version = BurnerSDK.shared.sdkVersion() {
    print("version: \(version)")
}
```

Note: If you want to use the SDK method `openBurnerApp()` you'll also need to define a value in your app's Info.plist:

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




