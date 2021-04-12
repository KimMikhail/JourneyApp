//
//  PreviewPhotoViewController.swift
//  Journey
//
//  Created by  Mikhail on 09.04.2021.
//  Copyright © 2021  Mikhail. All rights reserved.
//

import UIKit

class PreviewPhotoViewController: UIViewController {

    
    @IBOutlet weak var photosView: PhotosView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
