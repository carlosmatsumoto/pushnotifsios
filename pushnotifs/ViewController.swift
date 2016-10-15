//
//  ViewController.swift
//  pushnotifs
//
//  Created by Kenji Matsumoto on 10/11/16.
//  Copyright © 2016 Carlos Kenji Matsumoto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logTokenTapped(_ sender: UIButton) {
        let token = FIRInstanceID.instanceID().token()
        let device = UIDevice.current.systemName
        print("InstanceID token: \(token)")
        print("Device type: \(device)")
        
        PgDBService.instance.saveDeviceID(uid: token!, device: device) { (data, status) in
            if status == "SUCCESS" {
                print("Successfully added!")
            } else {
                let alert = UIAlertController(title: "ERROR", message: status, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }

    
    
}

