//
//  ReportViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import UIKit

protocol ReportDelegate: class {
    
    func sendReport(_ isReport: Bool)
    
}

class ReportViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    private var sendButton: UIBarButtonItem!
    
    private var cancelButton: UIBarButtonItem!
    
    weak var delegate: ReportDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    @objc func click(_ sender: UIBarButtonItem) {
        
        switch sender {
        
        case sendButton:
            
            delegate?.sendReport(true)
            
        case cancelButton:
            
            delegate?.sendReport(false)
            
        default:
            
            break
            
        }
        
        self.dismiss(animated: true)
    }
}

private extension ReportViewController {
    func setup() {
        navigationItem.setBarAppearance(
            with: .barButtonRed,
            titleTextAttrs: UINavigationItem.titleAttributes,
            title: "Report"
        )
        
        navigationController?.navigationBar.tintColor = .white
        
        sendButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(click))
        
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(click))
        
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.rightBarButtonItem = sendButton
    }
}
