//
//  AddNewWordViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class AddNewWordViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newWordTF: UITextField!
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    @IBAction func clickSend(_ sender: UIButton) {
    }
}

private extension AddNewWordViewController {
    func setup() {
        definitionTextView.setCorner(radius: 15)
        sendButton.setCorner(radius: 10)
        
        view.backgroundColor = .separatorlineBlue
        containerView.backgroundColor = .separatorlineBlue
    }
}
