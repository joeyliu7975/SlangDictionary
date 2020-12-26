//
//  WrapperAnimationView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/26/20.
//

//import UIKit
//import Lottie
//
//class WrapperAnimationView: UIView {
//  
//  let animationView: AnimationView
//
//  let customLabel: UILabel
//  
//    init(animationName: String, message: String) {
//    self.animationView = AnimationView(name: animationName)
//        
//    self.customLabel = UILabel()
//    self.customLabel.text = message
//    self.customLabel.textColor = .white
//    self.customLabel.font = UIFont(name: "PingFang SC", size: 18)
//        
//    super.init(frame: .zero)
//        
//    commonInit()
//  }
//  
//  init() {
//    self.animationView = AnimationView()
//    self.customLabel = UILabel()
//    
//    super.init(frame: .zero)
//    
//    commonInit()
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  func commonInit() {
//    addSubview(animationView)
//    addSubview(customLabel)
//    
//    // If using auto layout
//    animationView.translatesAutoresizingMaskIntoConstraints = false
//    animationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//    animationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//    animationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//    animationView.bottomAnchor.constraint(equalTo: bottomAnchor ).isActive = true
//    
//    customLabel.translatesAutoresizingMaskIntoConstraints = false
//    customLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//    customLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//    customLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//    customLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//  }
//  
//  override func layoutSubviews() {
//    super.layoutSubviews()
//    // If not using auto layout
//    animationView.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: self.bounds.height - 30)
//    
//    customLabel.frame = CGRect(x: self.bounds.minX, y: self.bounds.maxY - 30, width: self.bounds.width, height: 30)
//  }
//  
//}
