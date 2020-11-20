//
//  ImageSourcePickerDialog.swift
//  Point Pay
//
//  Created by Gabriel Perez on 03/22/2019.
//  Copyright © 2019 point payments. All rights reserved.
//

import UIKit

class ImageSourcePickerDialog: UIAlertController {
    static let SOURCE_CAMARA = 0
    static let SOURCE_GALLERY = 1
    
    let picker = UIImagePickerController()
    
    var action: ((Int) -> ())? = nil
    
    func setupActions() {
        addAction(UIAlertAction(title: "Galería", style: .default, handler: { _ in
            self.action?(ImageSourcePickerDialog.SOURCE_GALLERY)
        }))
        
        addAction(UIAlertAction(title: "Cámara", style: .default, handler: { _ in
            self.action?(ImageSourcePickerDialog.SOURCE_CAMARA)
        }))
        
        addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
    }
    
    func pickPhoto(viewController: UIViewController) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        viewController.present(picker, animated: true, completion: nil)
    }
    
    func launchCamera(viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            viewController.present(picker,animated: true,completion: nil)
        } else {
            viewController.present(UIUtil.createSimpleAlert(message: "Este dispositivo no tiene cámara disponible."), animated: true, completion: nil)
        }
    }
}
