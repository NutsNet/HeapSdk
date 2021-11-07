//
//  HSdk.swift
//  HeapSdk
//
//  Created by Christophe Vichery on 11/5/21.
//

import Foundation
import UIKit
import MapKit

import Alamofire

private var queue = DispatchQueue(label: "hsdk.queue", qos: .background, attributes: .concurrent)

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
        queue.sync { HSdk.hsdkProcessEvent(event: event) }
        
        // Releasing event to the app
        catchEvent(event: event)
    }
}
    
public class HSdk: NSObject {
    
    public override init() {
        super.init()
        print("\n#### HeapSdk: init sdk 0.1.0")
        
        // Start swizzling event methods to catch events
        UIWindow.swizzleEventMethod()
    }
    
    // Process the event catched and send event to bakend with parameters
    //
    // parameters:
    //  . type, kind of object touched
    //  . class, class of object touched
    //  . location, where touched in view
    //  . timestamp, time whem view touched
    //  . info, get info about view like the name
    //
    static func hsdkProcessEvent(event: UIEvent) {
        var parameters = Parameters()
        parameters["timestamp"] = event.timestamp
        
        // Check view touched
        for touch in event.allTouches! {
            
            // Check if touch is released
            if touch.phase == .ended {
                parameters["type"] = "press up"
                
                // Check class of the view
                if let view = touch.view {
                    let classObj = type(of: view)
                    let classStr = String(describing: view)
                    
                    parameters["location"] = "(x: \(touch.location(in: view).x), y: \(touch.location(in: view).y))"
                    
                    // UIButton
                    if classObj == UIButton.self {
                        let button = view as! UIButton
                        parameters["class"] = "UIButton"
                        
                        if (button.imageView?.image) != nil {
                            // it seems this is not possible to get the name of the image
                            parameters["info"] = "image"
                        } else if let title = button.title(for: .normal) {
                            parameters["info"] = title
                        }
                    }
                    
                    // UILabel
                    if classObj == UILabel.self {
                        let label = view as! UILabel
                        parameters["class"] = "UILabel"
                        
                        if let title = label.text {
                            parameters["info"] = title
                        }
                    }
                    
                    // UIImageView
                    if classObj == UIImageView.self {
                        parameters["class"] = "UIImageView"
                    }
                    
                    // UIVisualEffectView
                    if classObj == UIVisualEffectView.self {
                        parameters["class"] = "UIVisualEffectView"
                    }
                    
                    // Table view
                    if classStr.contains("UITableViewCellContentView") {
                        parameters["class"] = "UITableViewCellContentView"
                        parameters["info"] = "user touched a cell in a table view"
                    }
                    
                    // Map
                    if classStr.contains("MKAnnotationView") {
                        parameters["class"] = "MKAnnotationView"
                        parameters["info"] = "user is selecting an annotation"
                    } else if classStr.contains("_MKBezierPathView") {
                        parameters["class"] = "_MKBezierPathView"
                        parameters["info"] = "user is selecting an annotation"
                    } else if classStr.contains("MKAnnotationContainerView") {
                        parameters["class"] = "MKAnnotationContainerView"
                        parameters["info"] = "user is using the map"
                    } else if classStr.contains("MapView") {
                        parameters["class"] = "MapView"
                        parameters["info"] = "user is using the map"
                    }
                    
                    // Chart
                    if classStr.contains("BarChartView") {
                        parameters["class"] = "BarChartView"
                        parameters["info"] = "user is using the chart"
                    }
                }
            }
        }
        
        // Check if we got enought data about the event to send to the backend
        if parameters["type"] != nil { HApi.shared.hapiPostEvent(parameters: parameters) { _ in } }
    }
}
