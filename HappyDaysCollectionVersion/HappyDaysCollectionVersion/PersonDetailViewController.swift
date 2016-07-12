//
//  NewPersonViewController.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 19/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit
import MobileCoreServices

class PersonDetailViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedTeam : Team? = nil
    var editedPerson : Person? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if (editedPerson != nil){
            navigationController?.navigationBar.topItem?.title = "Edit your person"
            fillForm()
        }
        // Do any additional setup after loading the view.
    }
    
    func fillForm(){
        nameTextField.text = editedPerson?.name
        
        if editedPerson!.image != nil {
            imageView.image = UIImage(data: editedPerson!.image!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        
        if let personName = nameTextField.text {
            if personName != "" {
                
                if (editedPerson == nil){
                    Person.createPersonWithName(personName, andImage: imageView.image, andTeam: selectedTeam!)
                } else {
                    editedPerson?.updatePersonWithName(personName, andImage: imageView.image, andTeam: selectedTeam!)
                }
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
