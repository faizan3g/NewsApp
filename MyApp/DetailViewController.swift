//
//  DetailViewController.swift
//  MyApp
//
//  Created by Faizan Ali Siddiqui on 4/4/19.
//  Copyright © 2019 Faizan Ali Siddiqui. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var selectedNewsDict = Dictionary<String, Any>()
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = selectedNewsDict["content"] as? String {
            detailDescriptionLabel.text = detail
        }
        if let imgURL = selectedNewsDict["urlToImage"] as? String {
            self.imgView.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "placeholder"))
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    var detailItem: [String : Any]? {
        didSet {
            // Update the view.
            //configureView()
        }
    }
}


    

    
    


