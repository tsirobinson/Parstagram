//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Tyler Robinson on 3/3/21.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentField.layer.borderColor = UIColor.black.cgColor
        commentField.layer.borderWidth = 0.75
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 0.75
        submitButton.layer.borderColor = UIColor.black.cgColor

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSubmitButton(_ sender: Any) {
        //create object to send to parse
        let post = PFObject(className: "Posts")
        //create custom dictionary values for object
        post["caption"] = commentField.text
        post["author"] = PFUser.current()!
        
        //send image to Parse
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        //save to parse
        post.saveInBackground { (success, error) in
            if success{
                print("Saved.")
                self.dismiss(animated: true, completion: nil)
            }else{
                print("Could not save.")
            }
        }
    }
    
    
    

    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
