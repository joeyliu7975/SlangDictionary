//
//  TermOfServiceViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/26/20.
//

import UIKit

class TermOfServiceViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    private func setup() {
        
        titleLabel.text = "用戶使用協議"

    }

}
