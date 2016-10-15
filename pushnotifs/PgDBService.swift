//
//  PgDBService.swift
//  pushnotifs
//
//  Created by Kenji Matsumoto on 10/13/16.
//  Copyright © 2016 Carlos Kenji Matsumoto. All rights reserved.
//

import Foundation
import Alamofire

typealias Completion = (_ data: AnyObject?, _ errMsg: String?) -> Void

class PgDBService{

    private static let _instance = PgDBService()
    
    static var instance: PgDBService {
        return _instance
    }
    
    func saveDeviceID(uid: String, device: String, onComplete: Completion?){
        let url = URL(string: SAVEDEVICE_URL)!
        var params: [String : String] = [:]

        params = ["token": uid, "device": device]
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response) in
            let result = response.result
            
            if let res = result.value as? Dictionary<String,AnyObject> {
                if 200 == res["status"] as! Int  {
                    print("device saved/updated successfuly")
                    onComplete?(nil, "SUCCESS")
                } else {
                    onComplete?(nil, "Couldn't Save Device")
                }
            } else {
                onComplete?(nil, "There was an error saving the device.")
            }
            
        }
    }

}
