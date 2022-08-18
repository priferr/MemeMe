//
//  ViewController.swift
//  MemeMe
//
//  Created by Priscilla Cosi on 05/08/22.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    
    //    @IBOutlet weak var navBar: UINavigationBar!
    
    //MARK: View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldProperty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 //       unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Text Field Properties
    
    func textFieldProperty() {
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
        
    //MARK: Pick An Image

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
                shareButton.isEnabled = true
            }
        }
    
    // MARK: Clear & Edit Text Fields
    
    @IBAction func topTextFieldClears(_ sender: UITextField) {
        if topTextField.text == "TOP" {
            topTextField.text = ""
        }
    }
    
    @IBAction func bottomTextFieldClears(_ sender: UITextField) {
        if bottomTextField.text == "BOTTOM" {
            bottomTextField.text = ""
        }
    }
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard Config
        
    func subscribeToKeyboardNotifications() {
        // keyboardWillShow
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //keyboardWillHide
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // keyboardWillShow
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        //keyboardWillHide
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
   
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func hideBars(isHidden: Bool) {
        toolBar.isHidden = isHidden
        navBar.isHidden = isHidden
    }
    
    // MARK: Meme Object
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        hideBars(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hideBars(isHidden: false)
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage )
        }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed {
                self.save(memedImage: memedImage)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelItem(_ sender: Any) {
        shareButton.isEnabled = false
        imagePickerView.image = nil
        textFieldProperty()
    }
    
}
