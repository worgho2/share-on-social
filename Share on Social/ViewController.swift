//
//  ViewController.swift
//  Share on Social
//
//  Created by otavio on 26/01/21.
//

import UIKit
import Photos
import QBImagePickerController

class ViewController: UIViewController {
    
    @IBOutlet weak var view01: UIView!
    @IBOutlet weak var view02: UIView!
    
    let picker = QBImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self 
        picker.allowsMultipleSelection = true
        picker.maximumNumberOfSelection = 12
        picker.showsNumberOfSelectedAssets = true
    }
    
    @IBAction func onShareFromUIView(_ sender: Any) {
        TikTokFacade.instance.shareImages(images: [
            view01.asImage(),
            view02.asImage(),
        ]) { (response) in
            print(response)
        }
    }
    
    @IBAction func onShareFromImageGallery(_ sender: Any) {
        picker.mediaType = .image
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func onShareFromVideoGallery(_ sender: Any) {
        let alert = UIAlertController(title: "Work in progress", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true) {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (t) in
                self.dismiss(animated: true, completion: nil)
                t.invalidate()
            }
        }
    }
}

extension ViewController: QBImagePickerControllerDelegate {
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        guard let assets = assets as? [PHAsset] else {
            return
        }
        
        TikTokFacade.instance.shareImages(assets: assets) { (response) in
            print(response)
        }
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

