//
//  NewDefinitionViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/7/20.
//

import UIKit

class NewDefinitionViewController: UIViewController {
    
    lazy var textView: UITextView = {
        
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = self

        textView.backgroundColor = .newDefBlue
        
        textView.becomeFirstResponder()
    
        textView.tintColor = .white
        
        textView.setupContent(.startTyping(color: .white))
        
        return textView
    }()
    
    lazy var placeholderLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 300, height: 28))
        
        label.textColor = .lightGray
        label.text = "Write New Definition..."
        label.font = UIFont.init(name: "PingFang SC", size: 24.0)
        
        return label
    }()
    
    lazy var sendButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(send))
        
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)

        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .disabled)
        
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.homepageLightBlue], for: .normal)
        
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .disabled)
                
        return button
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .disabled)
        
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.homepageLightBlue], for: .normal)
        
        return cancelButton
    }()
    
    private var heightConstraint: NSLayoutConstraint?
    
    private var viewModel: NewDefinitionViewModel?
    
    var characterCounter = 0
    
    init(wordID: String) {
        
        viewModel = NewDefinitionViewModel(wordID: wordID)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        
        setupTextView()
        
        setupNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        
        textView.addSubview(placeholderLabel)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            guard let barHeight = self.navigationController?.navigationBar.bounds.height else { return }
            
            let height = view.bounds.height - keyboardSize.height - barHeight - 70
            
            heightConstraint = NSLayoutConstraint(
                item: textView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: height
            )
            
            textView.addConstraint(heightConstraint!)
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func send() {
        viewModel?.writeNewDefinition(completion: {
            dismiss(animated: true)
        })
    }
}

private extension NewDefinitionViewController {
    
    func setup() {
        
        navigationItem.setBarAppearance(with: .newDefBlue)
        
        view.backgroundColor = .newDefBlue
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardWillShow),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil
            )
        
        sendButton.isEnabled = false
    }
    
    func setupNavigation() {
                
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.rightBarButtonItem = sendButton
    }
    
    func setupTextView() {
        
        view.addSubview(textView)
                
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
                
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        
        textView.font = UIFont(name: "PingFang SC", size: 20.0)
    }
}

extension NewDefinitionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if let text = textView.text {
            
            switch text.isEmpty {
            case true:
                
                placeholderLabel.isHidden = false

                sendButton.isEnabled = false
            case false:
                
                placeholderLabel.isHidden = true

                sendButton.isEnabled = true

                viewModel?.textViewContent(text)
            }
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let validString = NSCharacterSet.textViewValidString

        if (textView.textInputMode?.primaryLanguage == "emoji") || textView.textInputMode?.primaryLanguage == nil {
            return false
        }
        
        if text.rangeOfCharacter(from: validString as CharacterSet) != nil {
            
            return false
        }
        
        return true
    }
}
