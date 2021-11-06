//
//  HSdk.swift
//  HeapSdk
//
//  Created by Christophe Vichery on 11/5/21.
//

import Foundation


public class HSdk: NSObject {
    
    public let shared = HSdk()
    override init() {
        super.init()
        
        print("Heap SDK initialized")
    }
}
