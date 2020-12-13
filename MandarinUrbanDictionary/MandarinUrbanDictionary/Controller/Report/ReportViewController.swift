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
    
    private var heightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var textViewHeightAnchor: NSLayoutConstraint!
    
    lazy var placeHolder: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 6, width: 200, height: 28))
        
        label.text = "Please tell us why..."
        
        label.font = UIFont(name: "PingFang SC", size: 22)
        
        label.textColor = .lightGray
        
       return label
    }()
    
    lazy var textFieldFullHeight:CGFloat = {
       self.view.frame.size.height - 100
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
        listenTokeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

extension ReportViewController {
    
    func listenTokeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //Adding this outside viewDidLoad
    @objc func keyboardWillShow(notification: NSNotification){
       
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keybardFrame = keyboardSize.cgRectValue
        
        let textFieldHalfHeight = textViewHeightAnchor.constant - (navigationController?.navigationBar.frame.height ?? 0) - keybardFrame.height - 140
        
        textViewHeightAnchor.constant = textFieldHalfHeight
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        
    }
    
}

private extension ReportViewController {
    func setup() {
        navigationItem.setBarAppearance(
            with: .reportDarkBlue,
            titleTextAttrs: UINavigationItem.titleAttributes,
            title: "Report"
        )
        
        navigationController?.navigationBar.tintColor = .white
        
        sendButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(click))
        
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(click))
        
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.rightBarButtonItem = sendButton
        
        textView.addSubview(placeHolder)
        
        textView.becomeFirstResponder()
        
        textView.returnKeyType = .default
    }
}
