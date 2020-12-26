//
//  ReportViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import UIKit

protocol ReportDelegate: class {
    
    func sendReport(_ isReport: Bool, reason: String?)
    
}

class ReportViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    private var sendButton: UIBarButtonItem!
    
    private var cancelButton: UIBarButtonItem!
    
    weak var delegate: ReportDelegate?
    
    private var heightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var textViewHeightAnchor: NSLayoutConstraint!
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 6, width: 280, height: 28))
        
        label.text = "請問讓我們了解為何檢舉此解釋"
        
        label.font = UIFont(name: "PingFang SC", size: 20)
        
        label.textColor = .gray
        
       return label
    }()
    
    lazy var textFieldFullHeight: CGFloat = {
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
    }
    
    @objc func click(_ sender: UIBarButtonItem) {
        
        switch sender {
        
        case sendButton:
            
            delegate?.sendReport(true, reason: textView.text)
            
        case cancelButton:
            
            delegate?.sendReport(false, reason: textView.text)
            
        default:
            
            break
            
        }
        
        self.dismiss(animated: true)
    }
}

extension ReportViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        switch textView.text.isEmpty {
        case true:
            placeholderLabel.isHidden = false
            sendButton.isEnabled = false
        case false:
            placeholderLabel.isHidden = true
            sendButton.isEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let validString = NSCharacterSet.textViewValidString

        if (textView.textInputMode?.primaryLanguage == "emoji") || textView.textInputMode?.primaryLanguage == nil {
            return false
        }
        
        if let _ = text.rangeOfCharacter(from: validString as CharacterSet) {
            
            return false
        }
        
        return true
    }
    
}

extension ReportViewController {
    
    func listenTokeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        textViewHeightAnchor.constant = textFieldFullHeight
       
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keybardFrame = keyboardSize.cgRectValue
        
        let textFieldHalfHeight = textViewHeightAnchor.constant - (navigationController?.navigationBar.frame.height ?? 0) - keybardFrame.height
        
        textViewHeightAnchor.constant = textFieldHalfHeight
    }
}

private extension ReportViewController {
    
    func setup() {
        
        overrideUserInterfaceStyle = .light
        
        navigationItem.setBarAppearance(
            with: .barButtonRed,
            titleTextAttrs: UINavigationItem.titleAttributes,
            title: "檢舉"
        )
        
        navigationController?.navigationBar.tintColor = .white
        
        sendButton = UIBarButtonItem(title: "發送", style: .plain, target: self, action: #selector(click))
        
        sendButton.isEnabled = false
                
        cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(click))
        
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.rightBarButtonItem = sendButton
        
        textView.addSubview(placeholderLabel)
        
        textView.becomeFirstResponder()
        
        textView.returnKeyType = .default
        
        textView.delegate = self
    }
}
