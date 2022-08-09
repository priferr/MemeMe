//
//  ViewController.swift
//  MemeMe
//
//  Created by Priscilla Cosi on 05/08/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //MARK: Text Field Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldProperty()
    }
    
    func textFieldProperty() {
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.delegate = self
       // topTextField.defaultTextAttributes = memeTextAttributes
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
        //bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    //let memeTextAttributes: [NSAttributedString.Key: Any] = [
    //    NSAttributedString.Key.strokeColor: /* TODO: fill in //appropriate UIColor */,
     //   NSAttributedString.Key.foregroundColor: /* TODO: fill in //appropriate UIColor */,
      //  NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
     //   NSAttributedString.Key.strokeWidth:  /* TODO: fill in //appropriate Float */
  //  ]
    
    // MARK: Clear & Edit Text Fields
    
    @IBAction func topTextFieldClears(_ sender: UITextField) {
        topTextField.text = ""
    }
    
    @IBAction func bottomTextFieldClears(_ sender: UITextField) {
        bottomTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //MARK: Pick An Image
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    @IBAction func PickImagePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func PickImageCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Show Chosen Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
                imagePickerView.image = chosenImage
                dismiss(animated: true, completion: nil)
                //shareBarButtonItem.isEnabled = true
        }
    }
}
    
