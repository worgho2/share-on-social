//
//  ViewController.swift
//  Share on Social
//
//  Created by otavio on 26/01/21.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var viewToShare2: UIView!
    @IBOutlet weak var viewToShare: UIView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onShareButton(_ sender: Any) {
        TikTokFacade.instance.shareImages([
            viewToShare.asImage(),
            viewToShare2.asImage()
        ]) { (responseStatus, state) in
            print(responseStatus, state)
        }

    }
    
}

