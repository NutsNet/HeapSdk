//
//  HSdk.swift
//  HeapSdk
//
//  Created by Christophe Vichery on 11/5/21.
//

import Foundation
import MapKit

import Alamofire

public extension UIWindow {
    // Swizzeling sendEvent method with our custom catchEvent method
    static func swizzleEventMethod() {
        print("#### HeapSdk: start catching event\n")
        
        let originalMethod = class_getInstanceMethod(UIWindow.self, #selector(sendEvent(_:)))!
        let swizzledMethod = class_getInstanceMethod(UIWindow.self, #selector(catchEvent(event:)))!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    // The SDK will catch any events coming from the testing app
    @objc func catchEvent(event: UIEvent) {
        // Event processing
        HSdk.hapiProcessEvent(event: event)
        
        // Releasing event to the app
        catchEvent(event: event)
    }
}
    
public class HSdk: NSObject {
    
    public override init() {
        super.init()
        print("\n#### HeapSdk: init sdk")
        
        // Start swizzling event methods to catch events
        UIWindow.swizzleEventMethod()
    }
    
    // Process the event catched and send event to bakend with parameters
    //
    // parameters:
    //  . type, class of the view touched
    //  . locstion, where touched in view
    //  . timestamp, time whem view touched
    //  . info, get info about view like the name
    //
    static func hapiProcessEvent(event: UIEvent) {
        var parameters = Parameters()
        parameters["timestamp"] = event.timestamp
        
        // Check view touched
        for touch in event.allTouches! {
            
            // Check if touch is released
            if touch.phase == .ended {
                
                // Check class of the view
                if let view = touch.view {
                    print("VIEW : \(type(of: view))")
                    parameters["location"] = "(x: \(touch.location(in: view).x), y: \(touch.location(in: view).y))"
                    
                    // UIButton
                    if type(of: view) == UIButton.self {
                        let button = view as! UIButton
                        parameters["type"] = "button"
                        
                        if (button.imageView?.image) != nil {
                            // it seems this is not possible to get the name of the image
                            parameters["info"] = "image"
                        } else if let title = button.title(for: .normal) {
                            parameters["info"] = title
                        }
                    }
                }
            }
        }
        
        // Check if we got enought data about the event to send to the backend
        if parameters["type"] != nil { HApi.shared.hsdkPostEvent(parameters: parameters) }
    }
}
