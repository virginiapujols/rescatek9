//
//  AddRescuePetViewController.swift
//  RescateK9
//
//  Created by Virginia Pujols on 11/15/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddRescuePetViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var sizeSegmentedCtrl: UISegmentedControl!
    @IBOutlet weak var genderSegmentedCtrl: UISegmentedControl!
    @IBOutlet weak var ageSegmentedCtrl: UISegmentedControl!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var rescuePicture: UIImageView!
    @IBOutlet weak var uploadPictureButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let imageSourcePickerDialog = ImageSourcePickerDialog()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
        imageSourcePickerDialog.setupActions()
        imageSourcePickerDialog.picker.delegate = self

    }
    
    @IBAction func uploadPictureButtonPressed(_ sender: Any) {
        imageSourcePickerDialog.action = { (source) in
            switch source {
            case ImageSourcePickerDialog.SOURCE_CAMARA:
                self.imageSourcePickerDialog.launchCamera(viewController: self)
                break
            case ImageSourcePickerDialog.SOURCE_GALLERY:
                self.imageSourcePickerDialog.pickPhoto(viewController: self)
                break
            default:
                self.imageSourcePickerDialog.pickPhoto(viewController: self)
            }
        }
        
        present(imageSourcePickerDialog, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let collection = Firestore.firestore().collection("rescues")

        guard let name = nameTextField.text, !name.isEmpty,
              let breed = breedTextField.text,  !breed.isEmpty,
              let comments = commentTextField.text,  !comments.isEmpty,
              let size = RescuePetSize(rawValue: sizeSegmentedCtrl.selectedSegmentIndex),
              let gender = Gender(rawValue: genderSegmentedCtrl.selectedSegmentIndex),
              let age = RescuePetAge(rawValue: ageSegmentedCtrl.selectedSegmentIndex),
              let picture = rescuePicture.image
        else {
            let alertVC = UIUtil.createSimpleAlert(message: "Todos los campos son requeridos.")
            self.present(alertVC, animated: true)
            return
        }
        
        let rescuePet = RescuePet(name: name, breed: breed, size: size, gender: gender, ageRange: age, comments: comments, documentId: nil)
        var docRef: DocumentReference? = nil
        docRef = collection.addDocument(data: rescuePet.dictionary, completion: { [unowned self] (error) in
            if let documentID = docRef?.documentID {
                self.uploadImageFor(documentID, image: picture)
            } else if let error = error {
                let alertVC = UIUtil.createSimpleAlert(message: error.localizedDescription)
                self.present(alertVC, animated: true)
            } else {
                let alertVC = UIUtil.createSimpleAlert(message: "Error desconocido. Favor intentár más tarde.")
                self.present(alertVC, animated: true)
            }
        })
    }
    
    private func uploadImageFor(_ documentID: String, image: UIImage) {
        let storage = Storage.storage().reference()
        guard let data = image.pngData() else { return }
        let storageChildRef = storage.child("images/\(documentID).png")
        
        let uploadTask = storageChildRef.putData(data, metadata: nil) { [unowned self] (metadata, error) in
            if let error = error {
                print("error uploading image \(error.localizedDescription)")
                return
            }
            
            // if there's data information
            storageChildRef.downloadURL { [unowned self]  (url, error) in
                guard let url = url else {
                    print("error uploading image \(error?.localizedDescription ?? "")")
                    return
                }
                
                print("Finished uploadTask with URL \(url)")
                self.navigationController?.popViewController(animated: true)
            }
        }

        // Add a progress observer to an upload task
        uploadTask.observe(.progress) { [unowned self] snapshot in
            DispatchQueue.main.async {
                let percentComplete = Float(snapshot.progress!.completedUnitCount) / Float(snapshot.progress!.totalUnitCount)
                print("progress \(percentComplete)")
                self.progressView.progress = percentComplete
            }
        }

    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddRescuePetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        rescuePicture.image = info[.editedImage] as? UIImage
        rescuePicture.image = info[.originalImage] as? UIImage

        // If the image is added correctly, then remove the camera icon from the button.
        let buttonImage = rescuePicture.image == nil ? UIImage(named: "camera.fill") : nil
        uploadPictureButton.setImage(buttonImage, for: .normal)
        
        // Dismiss the imagePicker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
