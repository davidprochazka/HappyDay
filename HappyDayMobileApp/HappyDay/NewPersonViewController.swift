//
//  NewPersonViewController.swift
//  HappyDay
//
//  Created by David Prochazka on 09/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

//
//  NewTeamViewController.swift
//  HappyDay
//
//  Created by David Prochazka on 09/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit
import MobileCoreServices


class NewPersonViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedTeam: Team? = nil // team selected in previous step
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        if let personName = nameTextField.text {
            if personName != "" {
                Person.createPersonWithName(personName, andImage: imageView.image!, inTeam: selectedTeam!)
                dismissViewControllerAnimated(true, completion: nil)
            } else {
                nameTextField.becomeFirstResponder()
            }
        } else {
            nameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ImagePicker
    
    @IBAction func loadPhoto(sender : AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        picker.mediaTypes = [kUTTypeImage as String]
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            imageView.image = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = possibleImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
