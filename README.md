# Heap SDK challenge how to:

## Introduction

I try Heap SDK with two test applications I built as a challenge for two companies ( [Fleetio](https://www.fleetio.com/) & [Divvy](https://getdivvy.com/) ) during a recrutment process:

1. Repository of [FleetioTest](https://github.com/NutsNet/FleetioTest)
2. Repository of [DivvyTest](https://github.com/NutsNet/DivvyTest)

They are all including already the HeapSdk pod

## Instalation

### Application

Be sure your application has a minimum deployment target of iOS 14.0

### Podfile

In your podfile add the HeapSdk pod and check the platform version is at least 14.0 as bellow.

```
platform :ios, '14.0'
use_frameworks!

target 'FleetioTest' do
  pod 'Alamofire'
  pod 'HeapSdk'
end
```

Run the following command App folder
1. rm -rf Pods // optional
2. pod repo update // optional
3. pod install
4. pod update

### Info.plist

Add the following to allow the SDK to communicate with the backend

```
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### AppDelegate.swift

Import HeapSdk at the top of the file and in the didFinishLaunchingWithOptions function add one line of code to init and run the SDK.

```
import UIKit
import HeapSdk

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
// Override point for customization after application launch.

    // Init and run HeapSdk
    _ = HSdk()

    return true
}
```

## Conclusion

This challenge allow me to get back in the SDK world and learn more about it. It took me more than 4 hours around 7hours, I had to learn how to release a version on cocoapods.

I was able to build, setup, install & release the SDK. The SDK is mainly doing is job, tracking the events and sending them to the backend.

But when it comes to detect whitch object the user is interacting with in the app this can be really tricky. In my case I was only able to detect the UIButton and get some data about it. The other elements were to difficut to detect...
