//
//  UIUtil.swift
//  Point Pay
//
//  Created by Gabriel Perez on 03/22/2019.
//  Copyright © 2019 point payments. All rights reserved.
//

import UIKit

class UIUtil {
    
    class func createSimpleAlert(title: String? = nil, message: String, action: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: action)
        
        alertVC.addAction(okAction)
        
        return alertVC
    }
    
    class func createConfirmAlert(title: String? = nil, message: String, okActionTitle: String = "Aceptar", cancelActionTitle: String = "Cancelar", action: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: action)
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        return alertVC
    }
}
