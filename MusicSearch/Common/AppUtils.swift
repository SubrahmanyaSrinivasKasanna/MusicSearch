//
//  AppUtils.swift
//  MusicSearch
//
//  Created by Srinivas Kasanna on 9/16/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import Foundation
import UIKit

struct AppUtils {
    
    static func showAlert(controller: UIViewController, title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
