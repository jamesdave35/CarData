//
//  ViewController.swift
//  CarData
//
//  Created by James Meli on 1/31/20.
//  Copyright © 2020 James Meli. All rights reserved.
//

import UIKit
import IBAnimatable
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var yearTextField: AnimatableTextField!
    @IBOutlet weak var modelTextField: AnimatableTextField!
    @IBOutlet weak var makeTextField: AnimatableTextField!
    @IBOutlet weak var carPhoto: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var imagePicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        self.carPhoto.isUserInteractionEnabled = true
        self.carPhoto.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func presentImagePicker() {
        //Initialize an alertview to prompt to the user on how to choose his profile picture
        let alertController = UIAlertController(title: NSLocalizedString("Add a Picture", comment: "add"), message: NSLocalizedString("Choose From", comment: "message"), preferredStyle: .actionSheet)
        //Initialize 4 actions for the different ways in which the user can choose his profile image
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: NSLocalizedString("Photos Library", comment: "photos"), style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: NSLocalizedString("Saved Photos Album", comment: "direction"), style: .default) { (action) in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
        
        let removePhotoAction = UIAlertAction(title: "Remove photo", style: .destructive) { (action) in
            self.imagePicked = false
            self.carPhoto.contentMode = .scaleAspectFit
            self.carPhoto.image = UIImage(named: "default-photo")
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "dismiss"), style: .cancel, handler: nil)
        
        //Add the actions to the alert view controller
        if imagePicked {
            alertController.addAction(cameraAction)
            alertController.addAction(photosLibraryAction)
            alertController.addAction(savedPhotosAction)
            alertController.addAction(removePhotoAction)
            alertController.addAction(cancelAction)
        } else {
            alertController.addAction(cameraAction)
            alertController.addAction(photosLibraryAction)
            alertController.addAction(savedPhotosAction)
            alertController.addAction(cancelAction)
        }
        
        //Present the alert view from the navigation rightBarButtom item on iPad
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        
        //Present the alertView on iPhone or iPod
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func submitButtonPressed(_ sender: Any) {
        
        let ref = Firestore.firestore().collection("CarData").document()
        ref.setData(["make": self.makeTextField.text!, "model": self.modelTextField.text!, "year": self.yearTextField.text!]) { (error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            } else {
                print("Saved successfully")
            }
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.imagePicked = true
        self.carPhoto.contentMode = .scaleAspectFill
        self.carPhoto.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

