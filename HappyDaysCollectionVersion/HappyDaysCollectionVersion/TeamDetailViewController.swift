//
//  NewTeamViewController.swift
//  HappyDay
//
//  Created by David Prochazka on 09/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import UIKit
import MobileCoreServices


class TeamDetailViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var editedTeam: Team? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (editedTeam != nil){
            navigationController?.navigationBar.topItem?.title = "Edit your Team"
        
            fillForm()
        }
        // Do any additional setup after loading the view.
    }
    
    func fillForm(){
        nameTextField.text = editedTeam?.name
        
        if editedTeam!.image != nil {
            imageView.image = UIImage(data: editedTeam!.image!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
        if let teamName = nameTextField.text {
            if teamName != "" {
                
                
                if (editedTeam == nil){
                    Team.createTeamWithName(teamName, andImage: imageView.image)
                } else {
                    editedTeam?.updateTeamWithName(teamName, andImage: imageView.image)
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
