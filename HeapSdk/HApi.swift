//
//  HApi.swift
//  HeapSdk
//
//  Created by Christophe Vichery on 11/6/21.
//

import Foundation
import Alamofire

public class HApi: NSObject {
    
    public static let shared = HApi()
    public override init() {
        super.init()
    }
    
    func hapiPostEvent(parameters: Parameters, escap:@escaping (Dictionary<String, Any>) -> Void) {
        let url: String =  "http://httpbin.org/post"
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if case let json as Dictionary<String, Any> = (value as AnyObject).value(forKey: "json") {
                    print("\n#### HeapSdk: event catched and sent to backend")
                    print("\(json)\n")
                    escap(json)
                } else {
                    escap([:])
                    print("Error in hsdkPostEvent: empty json")
                }
            case .failure(let error):
                escap([:])
                print("Error in hsdkPostEvent: \(error.localizedDescription)")
            }
        }
    }
}
