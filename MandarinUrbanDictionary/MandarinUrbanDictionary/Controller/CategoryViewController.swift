//
//  CategoryViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }


    func setup() {
        categoryView.setCorner(radius: 20.0)
    }
}
