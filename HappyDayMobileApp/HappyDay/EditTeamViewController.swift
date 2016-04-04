//
//  EditTeamViewController.swift
//  HappyDay
//
//  Created by David Prochazka on 21/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//


import UIKit
import MobileCoreServices


class EditTeamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedTeam: Team? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(data: (selectedTeam?.image)!)
        self.nameTextField.text = selectedTeam?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        
        if let teamName = nameTextField.text {
            if teamName != "" {
                selectedTeam?.image = UIImagePNGRepresentation(imageView.image!)
                if let newName = nameTextField.text{
                    selectedTeam?.name = newName
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as!
                    AppDelegate
                    //
                    let context = appDelegate.managedObjectContext
                    // Save the context.
                    do {
                        try context.save()
                    } catch {
                        abort()
                    }
                    dismissViewControllerAnimated(true, completion: nil)
                } else {
                    // focus na textfield
                }
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
