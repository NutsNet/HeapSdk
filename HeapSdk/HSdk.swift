//
//  HSdk.swift
//  HeapSdk
//
//  Created by Christophe Vichery on 11/5/21.
//

import Foundation
import Alamofire

public class HSdk: NSObject {
    let hapi = HApi()
    
    public override init() {
        super.init()
        
        print("Heap SDK initialized 0.7")
        
        let parameters: Parameters = [
            "email": "vichery.christophe@gmail.com",
            "name": "Christophe Vichery"
        ]
        
        hapi.hsdkPostEvent(parameters: parameters)
    }
}
