//
//  ImageViewController.swift
//  MadoriRuler
//
//  Created by 田澤歩 on 2021/02/16.
//

import UIKit
import Firebase

class ImageViewController: UIViewController {
    
    private var databased: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databased = Database()
        
        databased.fechData()
        
    }
    
    
    
}
